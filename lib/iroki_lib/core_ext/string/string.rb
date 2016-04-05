module IrokiLib
  module CoreExt
    module String

      def hex? str
        str.match(/^#[0-9A-Fa-f]{6}$/)
      end

      def clean str
        str.gsub(/[^\p{Alnum}_]+/, "_").gsub(/_+/, "_")
      end

      def has_color? name
        name.match(/(.*)(\[&!color="#[0-9A-Fa-f]{6}"\])/)
      end
      alias already_checked? has_color?

      def clean_name name
        if name.nil?
          nil
        else
          if (match = has_color? name)
            name = match[1]
            color = match[2]

            clean(name) + color
          else
            clean(name)
          end
        end
      end
    end
  end
end
