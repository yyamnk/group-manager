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
      cannot [:destroy], Shop, :id => [*(1..23)]  # Shopは1-23のデフォルトの削除禁止
      cannot [:create, :update, :destroy], StockerPlace # 貸出場所は編集不可
    end
    if user.role_id == 3 then # for user (デフォルトのrole)
      can :manage, :welcome
      #
      # TODO: emailのconfirmで判定する
      # confirmした後のみ各種CURDできるようにさせたい．
      #
      # UserDetailの自分のレコードは作成, 更新, 読みが可能. 削除はだめ.
      can [:read, :create, :update], UserDetail, :user_id => user.id
      # 所有するGroupのレコードは自由に触れる
      can :manage, Group, :user_id => user.id
      # ユーザに紐付いている参加団体
      groups = Group.where( user_id: user.id ).pluck('id')
      # ユーザに紐付き & 副代表が登録済みの団体
      groups_with_subrep = get_groups_with_subrep(groups)
      # 貸出物品は自分の団体で副代表登録済みなら読み，更新を許可
      can [:read, :update], RentalOrder, :group_id => groups_with_subrep
      # 電力申請は自分の団体で副代表登録済みなら全て許可
      # ただしnewはidに無関係に許可
      can :manage, PowerOrder, :group_id => groups_with_subrep
      can :new, PowerOrder
      # ステージ利用申請は自分の団体で副代表登録済みなら読み，更新を許可
      can [:read, :update], StageOrder, :group_id => groups_with_subrep
      # 実施場所申請は自分の団体で副代表登録済みなら読み，更新を許可
      can [:read, :update], PlaceOrder, :group_id => groups_with_subrep
      # 従業員は自分の団体で副代表登録済みなら自由に触れる.
      # ただしnewはidに無関係に許可
      can :manage, Employee, :group_id => groups_with_subrep
      can :new, Employee
      # 販売食品は自分の団体で副代表登録済みなら自由に触れる．
      # ただしnewはidに無関係に許可
      can :manage, FoodProduct, :group_id => groups_with_subrep
      can :new, FoodProduct
      # 購入リストは自分が持つ販売食品に紐付いたもののみ自由に触れる
      food_ids = FoodProduct.where( group_id: groups ).pluck('id')
      can :manage, PurchaseList, :food_product_id => food_ids
      # 店舗リストは読み，新規作成を許可
      can [:read, :create], Shop
      # 副代表は自分の団体のみ自由に触れる．
      # だたしnewはidに無関係に許可
      can :manage, SubRep, :group_id => groups
      can :new, SubRep
    end
  end

  def get_groups_with_subrep(group_ids)
    # 副代表が登録済みのgroup_idsを返す
    subrep_groups = []
    for id in group_ids do
      if Group.find(id).is_exist_subrep
        subrep_groups.push(id)
      end
    end
    return subrep_groups
  end
end
