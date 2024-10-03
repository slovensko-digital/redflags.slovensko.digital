class Admin::Metais::ProjectOriginsController < ApplicationController
  before_action :get_project, only: [:craete, :edit, :update, :add_event, :add_supplier, :add_link, :add_document, :remove_event, :remove_supplier, :remove_link, :remove_document, :update_group_order]

  def create
    @project_origin = @project.project_origins.build(project_origin_params)
    if @project_origin.save
      redirect_to admin_metais_project_path(@project), notice: 'Projekt bol úspešne vytvorený.'
    else
      render :new
    end
  end

  def edit
    @project_info = @project.get_project_origin_info

    @project_origins = @project.project_origins
    @project_origin = @project_origins.find(params[:id])
    @ai_project_origin = @project_origins.joins(:origin_type).find_by(origin_types: { name: 'AI' })

    @assumption_events = @project_origins.flat_map { |project_origin| project_origin.events.assumpted }
    @real_events = @project_origins.flat_map { |project_origin| project_origin.events.real }

    @combined_suppliers = @project_origins.flat_map(&:suppliers).sort_by { |supplier| supplier.date || Time.zone.parse('2999-12-31') }
    @combined_links = @project_origins.flat_map(&:links)
    @combined_documents = @project_origins.flat_map(&:documents)

    @grouped_documents = @combined_documents.group_by(&:description).sort_by { |description, docs| docs.first.group_order || Float::INFINITY }
  end

  def update
    @project_origin = @project.project_origins.find(params[:id])
    current_project_info = @project.get_project_origin_info

    changed_params = detect_changes(current_project_info, project_origin_params.to_h)

    if changed_params.any? && @project_origin.update(changed_params)
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), notice: 'Projekt bol úspešne aktualizovaný.'
    else
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), notice: 'Žiadne nové informácie v projekte.'
    end
  end

  def add_event
    @project_origin = @project.project_origins.find(params[:project_origin_id])
    @event = @project_origin.events.build(event_params)

    if @event.save
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), notice: 'Aktivita bola úspešné pridaná.'
    else
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), alert: "Nastala chyba pri vytváraní aktivity: #{@event.errors.full_messages.to_sentence}"
    end
  end

  def add_supplier
    @project_origin = @project.project_origins.find(params[:project_origin_id])
    @supplier = @project_origin.suppliers.build(supplier_params)

    if @supplier.save
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), notice: 'Dodávateľ bol úspešné pridaný.'
    else
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), alert: "Nastala chyba pri vytváraní dodávateľa: #{@event.errors.full_messages.to_sentence}"
    end
  end

  def add_link
    @project_origin = @project.project_origins.find(params[:project_origin_id])
    @link = @project_origin.links.build(link_params)

    if @link.save
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), notice: 'Link bol úspešné pridaný.'
    else
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), alert: "Nastala chyba pri vytváraní linku: #{@event.errors.full_messages.to_sentence}"
    end
  end

  def add_document
    @project_origin = @project.project_origins.find(params[:project_origin_id])
    @document = @project_origin.documents.build(document_params)

    if @document.save
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), notice: 'Dokument bol úspešné pridaný.'
    else
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), alert: "Nastala chyba pri vytváraní dokumentu: #{@event.errors.full_messages.to_sentence}"
    end
  end

  def remove_event
    @project_origin = @project.project_origins.find(params[:project_origin_id])
    @project_event = @project_origin.events.find(params[:event_id])

    if @project_event.destroy
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), notice: 'Aktivita bola úspešne odstránená z harmonogramu.'
    else
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), alert: 'Nastala chyba pri odstraňovaní aktivity z harmonogramu.'
    end
  end

  def remove_supplier
    @project_origin = @project.project_origins.find(params[:project_origin_id])
    @project_supplier = @project_origin.suppliers.find(params[:supplier_id])

    if @project_supplier.destroy
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), notice: 'Dodávateľ bol úspešne odstránený.'
    else
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), alert: 'Nastala chyba pri odstraňovaní dodávateľa.'
    end
  end

  def remove_link
    @project_origin = @project.project_origins.find(params[:project_origin_id])
    @project_link = @project_origin.links.find(params[:link_id])

    if @project_link.destroy
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), notice: 'Link bol úspešne odstránený.'
    else
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), alert: 'Nastala chyba pri odstraňovaní linku.'
    end
  end

  def remove_document
    @project_origin = @project.project_origins.find(params[:project_origin_id])
    @project_document = @project_origin.documents.find(params[:document_id])

    if @project_document.destroy
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), notice: 'Dokument bol úspešne odstránený.'
    else
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), alert: 'Nastala chyba pri odstraňovaní dokumentu.'
    end
  end
  
  def update_group_order
    @project_origin = @project.project_origins.find(params[:project_origin_id])
    
    description = params[:description]
    group_order = params[:group_order].to_i

    Metais::ProjectDocument.where(description: description).update_all(group_order: group_order)

    flash[:notice] = "Zoskupenie dokumentov bolo úspešne updatované."
    redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin)
  end

  private

  def get_project
    @project = Metais::Project.find(params[:project_id])
  end

  def project_origin_params
    params.require(:metais_project_origin).permit(:title, :description, :guarantor, :project_manager, :start_date, :end_date, :status, :phase, :finance_source, :investment, :operation, :approved_investment, :approved_operation, :supplier, :supplier_cin, :targets_text, :documents_text, :links_text, project_events: [:name, :value, :date])
  end

  def event_params
    origin_type = Metais::OriginType.find_by(name: params[:event][:origin_type])
    event_type = Metais::ProjectEventType.find_by(name: params[:event][:event_type])
    params.require(:event).permit(:name, :value, :date).merge(origin_type: origin_type, event_type: event_type)
  end

  def supplier_params
    origin_type = Metais::OriginType.find_by(name: params[:supplier][:origin_type])
    supplier_type = Metais::SupplierType.find(params[:supplier][:supplier_type])
    params.require(:supplier).permit(:name, :value).merge(name: params[:supplier][:value], origin_type: origin_type, supplier_type: supplier_type)
  end

  def link_params
    origin_type = Metais::OriginType.find_by(name: params[:link][:origin_type])
    params.require(:link).permit(:name, :value).merge(origin_type: origin_type)
  end

  def document_params
    origin_type = Metais::OriginType.find_by(name: params[:document][:origin_type])
    params.require(:document).permit(:name, :value, :description).merge(origin_type: origin_type)
  end

  def detect_changes(current_project_info, new_params)
    finance_source_mappings = {"Medzirezortný program 0EK Informačné technológie financované zo štátneho rozpočtu" => "Štátny rozpočet"}
    changed_params = {}

    new_params.each do |field, new_value|
      current_value = current_project_info.send(field)

      if field == 'finance_source'
        current_value_mapped = finance_source_mappings[current_value] || current_value
        new_value_mapped = finance_source_mappings[new_value] || new_value

        if new_value.present? && new_value_mapped.to_s.strip != current_value_mapped.to_s.strip
          changed_params[field] = new_value
        end
      else
        if %w[end_date start_date].include?(field)
          new_value = new_value.present? ? Date.parse(new_value.to_s) : nil
          current_value = current_value.present? ? current_value.to_date : nil
        end

        if new_value.present? && new_value.to_s.strip != current_value.to_s.strip
          changed_params[field] = new_value
        end
      end
    end

    changed_params
  end
end