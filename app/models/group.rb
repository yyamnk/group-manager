class Group < ActiveRecord::Base
  belongs_to :group_category
  belongs_to :user

  validates :name, presence: true, uniqueness: true
  validates :user, presence: true
  validates :activity, presence: true
  validates :group_category, presence: true

  # simple_form, activeadminで表示するカラムを指定
  # 関連モデル.groupが関連モデル.group.nameと同等になる
  def to_s
    self.name
  end

  # このメソッドselfいらないな...
  def self.init_rental_order(id) # RentalOrderのレコードが無ければ数量0で登録する
    items_ids = RentalItem.all.pluck('id')
    items_ids.each{ |item_id|
      order = RentalOrder.new( group_id: id, rental_item_id: item_id, num: 0)
      order.save
    }
  end

  def init_stage_order # StageOrderのレコードが無ければ登録
    return unless group_category_id == 3 # ステージ企画でなければ戻る
    # 1日目，晴れ
    order = StageOrder.new( group_id: id, fes_date_id: 2, is_sunny: true, time: '未回答' )
    order.save
    # 1日目，雨
    order = StageOrder.new( group_id: id, fes_date_id: 2, is_sunny: false, time: '未回答' )
    order.save
    # 2日目，晴れ
    order = StageOrder.new( group_id: id, fes_date_id: 3, is_sunny: true, time: '未回答' )
    order.save
    # 2日目，雨
    order = StageOrder.new( group_id: id, fes_date_id: 3, is_sunny: false, time: '未回答' )
    order.save
  end

  def init_place_order
    return if group_category_id == 3 # ステージ企画ならば戻る
    order = PlaceOrder.new( group_id: id )
    order.save
  end
end
