class Admin::Metais::ProjectOriginsController < ApplicationController

  def create
    @project = Metais::Project.find(params[:project_id])
    @project_origin = @project.project_origins.build(project_origin_params)
    if @project_origin.save
      redirect_to admin_metais_project_path(@project), notice: 'Projekt bol úspešne vytvorený.'
    else
      render :new
    end
  end

  def edit
    @project = Metais::Project.find(params[:project_id])
    @project_info = @project.get_project_origin_info
    @project_origins = @project.project_origins
    @project_origin = Metais::ProjectOrigin.find(params[:id])
    @ai_project_origin = @project_origins.joins(:origin_type).find_by(origin_types: { name: 'AI' })

    @assumption_events = []
    @real_events = []
    @project_origins.each do |project_origin|
      @assumption_events.concat(project_origin.events.where(event_type: Metais::ProjectEventType.find_by(name: 'Predpoklad')))
      @real_events.concat(project_origin.events.where(event_type: Metais::ProjectEventType.find_by(name: 'Realita')))
    end
    @assumption_events.sort_by! { |event| event.date }
    @real_events.sort_by! { |event| event.date }

    @all_suppliers = []
    @project_origins.each do |project_origin|
      @all_suppliers.concat(project_origin.suppliers)
    end
    @all_suppliers.sort_by! { |event| event.date || Time.zone.parse('2999-12-31') }

    @all_links = []
    @project_origins.each do |project_origin|
      @all_links.concat(project_origin.links)
    end

    @all_documents = []
    @project_origins.each do |project_origin|
      @all_documents.concat(project_origin.documents)
    end
    
    @grouped_documents = @all_documents.group_by(&:description)
    @grouped_documents = @grouped_documents.sort_by { |description, docs| docs.first.group_order || Float::INFINITY }

    @project_origin = Metais::ProjectOrigin.includes(:documents, :suppliers).find(@project_origin.id)
  end

  def update
    @project = Metais::Project.find(params[:project_id])
    @project_origin = Metais::ProjectOrigin.find(params[:id])
    
    finance_source_mappings = {"Medzirezortný program 0EK Informačné technológie financované zo štátneho rozpočtu" => "Štátny rozpočet"}
  
    current_project_info = @project.get_project_origin_info
  
    new_params = project_origin_params.to_h
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
        if field == 'end_date' || field == 'start_date'
          new_value = new_value.present? ? Date.parse(new_value.to_s) : nil
          current_value = current_value.present? ? current_value.to_date : nil
        end
  
        if new_value.present? && new_value.to_s.strip != current_value.to_s.strip
          changed_params[field] = new_value
        end
      end
    end
  
    if changed_params.any? && @project_origin.update(changed_params)
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), notice: 'Projekt bol úspešne aktualizovaný.'
    else
      redirect_to edit_admin_metais_project_project_origin_path(@project, @project_origin), notice: 'Žiadne nové informácie pre projekt.'
    end
  end

  def add_event
    @project = Metais::Project.find(params[:project_id])
    @project_origin = Metais::ProjectOrigin.find(params[:project_origin_id])
    @project_info = @project.get_project_origin_info

    origin_type = Metais::OriginType.find_by(name: params[:event][:origin_type])
    event_type = Metais::ProjectEventType.find_by(name: params[:event][:event_type])
    event_params = params.require(:event).permit(:name, :value, :date)
                         .merge(origin_type: origin_type, event_type: event_type)
    @event = @project_origin.events.create(event_params)

    if @event.save
      redirect_to edit_admin_metais_project_project_origin_path(project_id: @project.id, id: @project_origin.id), notice: 'Event bol úspešné pridaný.'
    else
      redirect_to edit_admin_metais_project_project_origin_path(project_id: @project.id, id: @project_origin.id), alert: 'Error encountered while creating an event: ' + @event.errors.full_messages.to_sentence
    end
  end

  def add_supplier
    @project = Metais::Project.find(params[:project_id])
    @project_origin = Metais::ProjectOrigin.find(params[:project_origin_id])

    origin_type = Metais::OriginType.find_by(name: params[:supplier][:origin_type])
    supplier_type = Metais::SupplierType.find(params[:supplier][:supplier_type])

    supplier_params = params.require(:supplier).permit(:name, :value)
                         .merge(name: params[:supplier][:value], origin_type: origin_type, supplier_type: supplier_type)
    @supplier = @project_origin.suppliers.create(supplier_params)

    if @supplier.save
      redirect_to edit_admin_metais_project_project_origin_path(project_id: @project.id, id: @project_origin.id), notice: 'Supplier bol úspešné pridaný.'
    else
      redirect_to edit_admin_metais_project_project_origin_path(project_id: @project.id, id: @project_origin.id), alert: 'Error encountered while creating an event: ' + @event.errors.full_messages.to_sentence
    end
  end

  def add_link
    @project = Metais::Project.find(params[:project_id])
    @project_origin = Metais::ProjectOrigin.find(params[:project_origin_id])

    origin_type = Metais::OriginType.find_by(name: params[:link][:origin_type])

    link_params = params.require(:link).permit(:name, :value).merge(origin_type: origin_type)
    @link = @project_origin.links.create(link_params)

    if @link.save
      redirect_to edit_admin_metais_project_project_origin_path(project_id: @project.id, id: @project_origin.id), notice: 'Link bol úspešné pridaný.'
    else
      redirect_to edit_admin_metais_project_project_origin_path(project_id: @project.id, id: @project_origin.id), alert: 'Error encountered while creating an link: ' + @event.errors.full_messages.to_sentence
    end
  end

  def add_document
    @project = Metais::Project.find(params[:project_id])
    @project_origin = Metais::ProjectOrigin.find(params[:project_origin_id])

    origin_type = Metais::OriginType.find_by(name: params[:document][:origin_type])

    document_params = params.require(:document).permit(:name, :value, :description).merge(origin_type: origin_type)
    @document = @project_origin.documents.create(document_params)

    if @document.save
      redirect_to edit_admin_metais_project_project_origin_path(project_id: @project.id, id: @project_origin.id), notice: 'Dokument bol úspešné pridaný.'
    else
      redirect_to edit_admin_metais_project_project_origin_path(project_id: @project.id, id: @project_origin.id), alert: 'Error encountered while creating an document: ' + @event.errors.full_messages.to_sentence
    end
  end

  def remove_event
    @project = Metais::Project.find(params[:project_id])
    @project_origin = Metais::ProjectOrigin.find(params[:project_origin_id])
    @project_event = Metais::ProjectEvent.find(params[:event_id])
    @project_event.destroy
    redirect_to edit_admin_metais_project_project_origin_path(project_id: @project.id, id: @project_origin.id), notice: 'Event z harmonogramu bol úspešne odstránený.'
  end

  def remove_supplier
    @project = Metais::Project.find(params[:project_id])
    @project_origin = Metais::ProjectOrigin.find(params[:project_origin_id])
    @project_supplier = Metais::ProjectSupplier.find(params[:supplier_id])
    @project_supplier.destroy
    redirect_to edit_admin_metais_project_project_origin_path(project_id: @project.id, id: @project_origin.id), notice: 'Supplier bol úspešne odstránený.'
  end

  def remove_link
    @project = Metais::Project.find(params[:project_id])
    @project_origin = Metais::ProjectOrigin.find(params[:project_origin_id])
    @project_link = Metais::ProjectLink.find(params[:link_id])
    @project_link.destroy
    redirect_to edit_admin_metais_project_project_origin_path(project_id: @project.id, id: @project_origin.id), notice: 'Link bol úspešne odstránený.'
  end

  def remove_document
    @project = Metais::Project.find(params[:project_id])
    @project_origin = Metais::ProjectOrigin.find(params[:project_origin_id])
    @project_document = Metais::ProjectDocument.find(params[:document_id])
    @project_document.destroy
    redirect_to edit_admin_metais_project_project_origin_path(project_id: @project.id, id: @project_origin.id), notice: 'Dokument bol úspešne odstránený.'
  end
  
  def update_group_order
    @project = Metais::Project.find(params[:project_id])
    @project_origin = Metais::ProjectOrigin.find(params[:project_origin_id])
    
    description = params[:description]
    group_order = params[:group_order].to_i

    Metais::ProjectDocument.where(description: description).update_all(group_order: group_order)

    flash[:notice] = "Group order updated successfully."
    redirect_to edit_admin_metais_project_project_origin_path(project_id: @project.id, id: @project_origin.id)
  end

  private

  def project_origin_params
    params.require(:metais_project_origin).permit(:title, :description, :guarantor, :project_manager, :start_date, :end_date, :status, :phase, :finance_source, :investment, :operation, :approved_investment, :approved_operation, :supplier, :supplier_cin, :targets_text, :documents_text, :links_text, project_events: [:name, :value, :date])
  end
end