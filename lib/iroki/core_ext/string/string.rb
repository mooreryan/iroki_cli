module Iroki
  module CoreExt
    module String

      def has_color?
        self.match(/(.*)(\[&!color="#[0-9A-Fa-f]{6}"\])/)
      end
      alias already_checked? has_color?

      def hex?
        self.match(/^#[0-9A-Fa-f]{6}$/)
      end

      def clean
        self.gsub(/'/, '"')
      end

      def single_quote
        if self.match /\A'.*'\Z/
          self.dup
        else
          %Q['#{self.clean}']
        end
      end

      def clean_name
        if (match = self.has_color?)
          name = match[1]
          color = match[2]

          name.single_quote + color
        else
          self.single_quote
        end
      end

      def clean_strict
        self.strip.gsub(/[^\p{Alnum}_]+/, "_").gsub(/_+/, "_")
      end

      def has_single_quote?
        self.match(/'/)
      end
    end
  end
end
