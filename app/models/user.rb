class User < ActiveRecord::Base
  has_many :board_memberships
  has_many :boards, through: :board_memberships

  has_secure_password

  def admin_of?(board)
    board.admins.include? self
  end
end
