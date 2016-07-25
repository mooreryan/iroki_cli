module Iroki
  module CoreExt
    module String

      def hex?
        self.match(/^#[0-9A-Fa-f]{6}$/)
      end

      def clean
        self.gsub(/[^\p{Alnum}_]+/, "_").gsub(/_+/, "_")
      end

      def has_color?
        self.match(/(.*)(\[&!color="#[0-9A-Fa-f]{6}"\])/)
      end
      alias already_checked? has_color?

      def clean_name
        if (match = self.has_color?)
          name = match[1]
          color = match[2]

          name.clean + color
        else
          self.clean
        end
      end
    end
  end
end
