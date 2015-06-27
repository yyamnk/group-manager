class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    #

    user ||= User.new # guest user (not logged in)
    cannot :manage, :all

    if user.role_id == 1 then # for developer
      # 全てOK
      can :manage, :all
    end
    if user.role_id == 2 then # for manager
      can :manage, :all # 下記以外の全てOK
      cannot [:create, :update, :destroy], Role # roleの作成と編集, 編集, 削除は不可
      cannot [:create, :update, :destroy], User # roleを含むため, Userの作成, 編集, 削除は不可
      cannot [:create, :destroy], RentalOrder # 数量0で対応する．
      cannot [:create, :destroy], StageOrder
      cannot [:create, :destroy], PlaceOrder
      cannot [:destroy], Place # PlaceOrderからfindで引いている．削除は禁止
    end
    if user.role_id == 3 then # for user (デフォルトのrole)
      can :manage, :welcome
      # emailのconfirmが終わっていれば
      #
      # UserDetailの自分のレコードは作成, 更新, 読みが可能. 削除はだめ.
      can [:read, :create, :update], UserDetail, :user_id => user.id
      # 所有するGroupのレコードは自由に触れる
      can :manage, Group, :user_id => user.id
      # 貸出物品は自分の団体のみ読み，更新を許可
      groups = Group.where( user_id: user.id ).pluck('id')
      can [:read, :update], RentalOrder, :group_id => groups
      # 電力申請は自分の団体のみ作成，読み，更新，削除を許可
      can :manage, PowerOrder, :group_id => groups
      # ステージ利用申請は自分の団体のみ読み，更新を許可
      can [:read, :update], StageOrder, :group_id => groups
      # 実施場所申請は自分の団体のみ読み，更新を許可
      can [:read, :update], PlaceOrder, :group_id => groups
      # 従業員は自分の団体のみ自由に触れる
      can :manage, Employee, :group_id => groups
      # 販売食品は自分の団体のみ自由に触れる
      can :manage, FoodProduct, :group_id => groups
    end

  end

end
