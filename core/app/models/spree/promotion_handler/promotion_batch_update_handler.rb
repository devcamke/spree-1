module Spree
  module PromotionHandler
    class PromotionBatchUpdateHandler < Spree::PromotionDuplicatorCore
      def initialize(promotion, promotion_batch_id, descendant_promotion)
        @promotion = promotion
        @promotion_batch_id = promotion_batch_id
        @descendant_promotion = descendant_promotion
      end

      def duplicate
        @new_promotion = @promotion.dup
        @new_promotion.usage_limit = 1
        @new_promotion.promotion_batch_id = @promotion_batch_id
        @new_promotion.path = @descendant_promotion.path
        @new_promotion.code = @descendant_promotion.code
        @new_promotion.stores = @promotion.stores

        ActiveRecord::Base.transaction do
          @new_promotion.save
          copy_rules
          copy_actions
          @descendant_promotion.destroy!
        end

        @new_promotion
      end
    end
  end
end