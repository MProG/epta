ActiveAdmin.register Product do
  scope :sport
  scope :mobile

  index do
    selectable_column
    column :code
    column :name
    column :base_price
    column :current_price
    column :diff_percent
    column :location
    column :updated_at
    actions
  end


# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

end
