class Incident < ApplicationRecord
  validates :shift, {presence: true}
  validates :occurred_at, {presence: true}
  validates :title, {presence: true}
  validates :place, {presence: true, length: {maximum: 140}}
  validates :years, {presence: true}
  validates :target, {presence: true}
  validates :happened, {presence: true, length: {maximum: 140}}
  validates :user_id, {presence: true}

  has_many :unreads, dependent: :destroy

  belongs_to :department
  belongs_to :user

  #_formのための定数定義
  SHIFTS = [["日勤", "日勤"], ["日直", "日直"], ["当直", "当直"], ["呼び出し", "呼び出し"], ["その他", "その他"]]
  PLACES = [
    ["検査室", "検査室"], ["操作室", "操作室"], ["注射室", "注射室"], ["トイレ", "トイレ"], ["救急部", "救急部"],
    ["救急CT", "救急CT"], ["オペ室", "オペ室"], ["病棟", "病棟"],["その他", "その他"]
  ]
  TARGETS = [["患者", "患者"], ["装置＆物品", "装置＆物品"], ["その他", "その他"]]
  HAPPPENEDS = [
    ["検査（治療）の内容に関すること", "検査（治療）の内容に関すること"],
    ["オーダー間違い", "オーダー間違い"],
    ["MRI室への金属持ち込み", "MRI室への金属持ち込み"],
    ["線量に関すること", "線量に関すること"],
    ["患者に関すること（患者誤認、登録間違い等）", "患者に関すること（患者誤認、登録間違い等）"],
    ["点滴ルートなどの引き抜き", "点滴ルートなどの引き抜き"],
    ["転倒転落", "転倒転落"],
    ["患者の受傷（転倒・転落以外）", "患者の受傷（転倒・転落以外）"],
    ["患者情報の伝達に関すること", "患者情報の伝達に関すること"],
    ["技師以外のスタッフのミス", "技師以外のスタッフのミス"],
    ["物損", "物損"],
    ["装置の故障", "装置の故障"],
    ["その他", "その他"]
  ]

end
