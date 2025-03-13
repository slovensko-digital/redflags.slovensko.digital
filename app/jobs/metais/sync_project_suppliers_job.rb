require 'open-uri'
require 'nokogiri'

class Metais::SyncProjectSuppliersJob < ApplicationJob
  queue_as :metais

  def perform(project_origin, metais_project)
    origin_type = Metais::OriginType.find_by(name: 'MetaIS')

    if metais_project.latest_version.link_nfp.present?
      supplier_type = Metais::SupplierType.find_by(name: "NFP")

      link = metais_project.latest_version.link_nfp

      links = extract_links(link)
      links.each do |url|
        if valid_url?(url)
          project_supplier = Metais::ProjectSupplier.find_or_initialize_by(
            name: url,
            value: url,
            date: metais_project.latest_version.datum_nfp,
            project_origin: project_origin,
            origin_type: origin_type,
            supplier_type: supplier_type)

          project_supplier.save!
        end
      end
    end

    if metais_project.latest_version.vo.present?
      supplier_type = Metais::SupplierType.find_by(name: "VO")

      link = metais_project.latest_version.vo

      links = extract_links(link)
      links.each do |url|
        if valid_url?(url)
          project_supplier = Metais::ProjectSupplier.find_or_initialize_by(
            name: url,
            value: url,
            date: metais_project.latest_version.vyhlasenie_vo,
            project_origin: project_origin,
            origin_type: origin_type,
            supplier_type: supplier_type)

          project_supplier.save!
        end
      end
    end

    if metais_project.latest_version.zmluva_o_dielo_crz.present?
      supplier_type = Metais::SupplierType.find_by(name: "CRZ")

      link = metais_project.latest_version.zmluva_o_dielo_crz

      document = Nokogiri::HTML(open(link).read.force_encoding('UTF-8'))
      crz_data = parse_crz_document(document)

      if crz_data[:supplier] && crz_data[:cin]
        project_origin.supplier = crz_data[:supplier]
        project_origin.supplier_cin = crz_data[:cin]
        project_origin.save!
      end

      links = extract_links(link)
      links.each do |url|
        if valid_url?(url)
          project_supplier = Metais::ProjectSupplier.find_or_initialize_by(
            name: url,
            value: url,
            date: metais_project.latest_version.zmluva_o_dielo,
            project_origin: project_origin,
            origin_type: origin_type,
            supplier_type: supplier_type)

          project_supplier.save!
        end
      end

    end
  end

  private

  def valid_url?(url)
    uri = URI.parse(url)
    uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end

  def extract_links(str)
    uri_regexp = /\b(?:https?|ftp):\/\/\S+\b/
    str.to_s.scan(uri_regexp)
  end

  def parse_crz_document(document)
    li_elements = document.css('li.py-2.border-top')
    supplier_info = nil
    cin = nil

    li_elements.each_with_index do |li_element, i|
      supplier_label = li_element.at_css('strong.col-sm-3.text-sm-end')&.text&.strip
      if supplier_label == 'Dodávateľ:'
        supplier_info = li_element.at_css('span.col-sm-9')&.text&.strip
        cin_label = li_elements[i + 1].at_css('strong.col-sm-3.text-sm-end')&.text&.strip
        if cin_label == 'IČO:'
          cin = li_elements[i + 1].at_css('span.col-sm-9')&.text&.strip
          break if supplier_info && cin
        end
      end
    end

    { supplier: supplier_info, cin: cin }
  end
end
