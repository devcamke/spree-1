module Spree
  class PromotionBatch < Spree::Base
    validate :template_assignment, on: :update

    has_many :promotions
    belongs_to :template_promotion, class_name: "Promotion"

    def template_promotion_name_id
      base = template_promotion.name
      addon = template_promotion_id.to_s
      base.concat(' # ', addon)
    end

    def model_name_id
      base = self.class.name.demodulize
      addon = self.id.to_s
      base.concat(' # ', addon)
    end

    private

    def template_assignment
      if template_promotion_id_changed? && template_promotion_id_was.present?
        errors.add(:template_promotion_id, :template_promotion_already_assigned, message: Spree.t(:template_promotion_already_assigned))
      end
    end
  end
end
