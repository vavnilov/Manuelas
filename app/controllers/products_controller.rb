class ProductsController < ApplicationController
  helper_method :add_cart

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.create(product_params)
    redirect_to product_path(@product)
  end

  def show
    find_product
  end

  def edit
    find_product
  end

  def update
    find_product
    @product.update(product_params)
    render :show
  end

  private

  def find_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name,:description,:img_url)
  end

end
