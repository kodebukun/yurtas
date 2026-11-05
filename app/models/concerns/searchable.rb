module Searchable
  extend ActiveSupport::Concern

  class_methods do
    #キーワード検索（スペース区切りでAND検索、タイトルと本文が対象）
    def search(keyword)
      words = keyword.to_s.split(/[[:space:]]+/).reject(&:blank?)
      words.inject(all) do |records, word|
        pattern = "%#{sanitize_sql_like(word)}%"
        records.where("#{table_name}.title ILIKE :pattern OR #{table_name}.content ILIKE :pattern", pattern: pattern)
      end
    end
  end
end
