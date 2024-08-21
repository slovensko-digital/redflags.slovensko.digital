class Metais::SyncProjectSuppliersJob < ApplicationJob
  queue_as :metais

  ORIGIN_TYPE = Metais::OriginType.find_by(name: 'MetaIS')

  def perform(project_origin, metais_project)
    if metais_project.latest_version.link_nfp.present?
      supplier_type = Metais::SupplierType.find_by(name: "NFP")

      project_supplier = Metais::ProjectSupplier.find_or_initialize_by(
        name: metais_project.latest_version.link_nfp,
        value: metais_project.latest_version.link_nfp,
        date: metais_project.latest_version.datum_nfp,
        project_origin: project_origin,
        origin_type: ORIGIN_TYPE,
        supplier_type: supplier_type)

      project_supplier.save!
    end

    if metais_project.latest_version.vo.present?
      supplier_type = Metais::SupplierType.find_by(name: "VO")

      project_supplier = Metais::ProjectSupplier.find_or_initialize_by(
        name: metais_project.latest_version.vo,
        value: metais_project.latest_version.vo,
        date: metais_project.latest_version.vyhlasenie_vo,
        project_origin: project_origin,
        origin_type: ORIGIN_TYPE,
        supplier_type: supplier_type)

      project_supplier.save!
    end

    if metais_project.latest_version.zmluva_o_dielo_crz.present?
      supplier_type = Metais::SupplierType.find_by(name: "CRZ")

      project_supplier = Metais::ProjectSupplier.find_or_initialize_by(
        name: metais_project.latest_version.zmluva_o_dielo_crz,
        value: metais_project.latest_version.zmluva_o_dielo_crz,
        date: metais_project.latest_version.zmluva_o_dielo,
        project_origin: project_origin,
        origin_type: ORIGIN_TYPE,
        supplier_type: supplier_type)

      project_supplier.save!
    end
  end
end
