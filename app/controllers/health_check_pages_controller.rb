class HealthCheckPagesController < ApplicationController

  def preview_pdf_page(template_name, output_file_name)
    respond_to do |format|
      format.pdf do
        # 詳細画面のHTMLを取得
        html = render_to_string template: "health_check_pages/#{template_name}"

        # PDFKitを作成
        pdf = PDFKit.new(html, encoding: "UTF-8")

        # 画面にPDFを表示する
        # to_pdfメソッドでPDFファイルに変換する
        # 他には、to_fileメソッドでPDFファイルを作成できる
        # disposition: "inline" によりPDFはダウンロードではなく画面に表示される
        send_data pdf.to_pdf,
          filename:    "保健所提出書類_#{output_file_name}.pdf",
          type:        "application/pdf",
          disposition: "inline"
      end
    end
  end

  def cooking
    this_year = FesYear.this_year
    @food_products = FoodProduct.cooking_products(this_year.id)
    @fes_dates = this_year.fes_date.all()

    preview_pdf_page("cooking", "調理有り")
  end

  def no_cooking
    this_year = FesYear.this_year
    @food_products = FoodProduct.non_cooking_products(this_year.id)

    @fes_dates = this_year.fes_date.all()
    preview_pdf_page("no_cooking", "調理無し")
  end

end
