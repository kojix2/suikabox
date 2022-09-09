require 'suika'
require 'glimmer-dsl-libui'

include Glimmer

tagger = Suika::Tagger.new
data = [[]]

window('SuikaBox', 800, 500) do
  margined true

  vertical_box do
    @input = multiline_entry do
      stretchy false
      text "山路を登りながら、こう考えた。\n" +
           '智に働けば角が立つ。情に棹させば流される。意地を通せば窮屈だ。とかくに人の世は住みにくい。'
    end
    horizontal_box do
      stretchy false
      button('消去') do
        stretchy false
        on_clicked do
          @input.text = ''
        end
      end
      button('解析') do
        stretchy false
        on_clicked do
          data.replace(
            tagger.parse(@input.text.force_encoding('UTF-8')).map do |line|
              h, _, l = line.rpartition("\t") # コンマやタブの対策
              [h].concat(l.split(','))
            end
          )
        end
      end
    end
    table do
      %w[表層形 品詞 分類１ 分類２ 分類３ 活用型 活用形 原形 読み 発音].each do |h|
        text_column(h)
      end
      cell_rows data
      editable false
    end
    label do
      stretchy false
      text "Suika #{Suika::VERSION}"
    end
  end
end.show
