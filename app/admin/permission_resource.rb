ActiveAdmin.register PermissionResource do
  
  menu label: '权限资源', priority: 3
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :func_name, :func_class, :sort, :opened, 
  permissions_attributes: [:id, :action, :action_name, :memo, :need_scope, :_destroy]
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

index do
  selectable_column
  id_column
  column :func_name
  column :func_class
  column '权限操作' do |o|
    raw(o.permissions.all.map { |p| [p.action_name] }.join('<br>'))
  end
  column 'at', :created_at
  actions
end

form do |f|
  f.semantic_errors
  f.inputs '基本信息' do
    f.input :func_name
    f.input :func_class
    f.input :sort
    f.input :opened
  end
  f.inputs '权限信息' do
    f.has_many :permissions, allow_destroy: true, heading: '' do |item_form|
      item_form.input :action
      item_form.input :action_name
      item_form.input :need_scope
      item_form.input :memo
    end
  end
  actions
end

end
