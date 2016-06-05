class HealthCheckPagesController < ApplicationController

  def index
    # 今年のレコード
    this_year = FesYear.where(fes_year: Time.now.year)
    # 自分の所有するグループで今年に紐づくもの
    @food_products = FoodProduct.where(is_cooking: true)
    @fes_dates =FesDate.all
    # ログインユーザの所有しているグループのうち，
    respond_to do |format|
      format.pdf do
        # 詳細画面のHTMLを取得
        html = render_to_string template: "health_check_pages/index"

        # PDFKitを作成
        pdf = PDFKit.new(html, encoding: "UTF-8")

        # 画面にPDFを表示する
        # to_pdfメソッドでPDFファイルに変換する
        # 他には、to_fileメソッドでPDFファイルを作成できる
        # disposition: "inline" によりPDFはダウンロードではなく画面に表示される
        send_data pdf.to_pdf,
          filename:    "#health_check_all.pdf",
          type:        "application/pdf",
          disposition: "inline"
      end   # 副代表が登録されていない団体数を取得する
    end
  end

  def no_cooking
    # 今年のレコード
    this_year = FesYear.where(fes_year: Time.now.year)
    # 自分の所有するグループで今年に紐づくもの
    @food_products = FoodProduct.where(is_cooking: false)
    @fes_dates =FesDate.all
    # ログインユーザの所有しているグループのうち，
    # 副代表が登録されていない団体数を取得する
    respond_to do |format|
      format.pdf do
        # 詳細画面のHTMLを取得
        html = render_to_string template: "health_check_pages/no_cooking"

        # PDFKitを作成
        pdf = PDFKit.new(html, encoding: "UTF-8")

        # 画面にPDFを表示する
        # to_pdfメソッドでPDFファイルに変換する
        # 他には、to_fileメソッドでPDFファイルを作成できる
        # disposition: "inline" によりPDFはダウンロードではなく画面に表示される
        send_data pdf.to_pdf,
          filename:    "#health_check_all_no_cooking.pdf",
          type:        "application/pdf",
          disposition: "inline"
      end   # 副代表が登録されていない団体数を取得する
    end
  end

end
