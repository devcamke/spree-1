module Spree
  module Cart
    class Destroy
      prepend Spree::ServiceModule::Base

      def call(order:)
        run :check_if_can_be_destroyed
        run :cancel_shipments
        run :void_payments
        run :destroy_order
        run :notify_order_stream # or should be moved one stage up ?
      end

      private

      def notify_order_stream(order:)
        Rails.configuration.event_store.publish(
          ::Checkout::Event::DestroyCart.new(data: { order: order.as_json }),
          stream_name: "customer_#{order.email}"
        )

        success(order)
      end

      def check_if_can_be_destroyed(order:)
        return failure(Spree.t(:cannot_be_destroyed)) unless order&.can_be_destroyed?

        success(order: order)
      end

      def cancel_shipments(order:)
        order.shipments.each(&:cancel!)

        success(order: order)
      end

      def void_payments(order:)
        order.payments.each(&:void!)

        success(order: order)
      end

      def destroy_order(order:)
        order.destroy

        success(order: order)
      end
    end
  end
end
