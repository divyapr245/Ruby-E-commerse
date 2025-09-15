class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :rating,  :account_details, :created_at

  def account_details 
    {
      id: object.account.id,
      email: object.account.email
    }
    
  end
end