class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all.includes(:category)
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @times_ordered = Order.where("orders.checkout_date is not null").
    joins("JOIN order_contents ON order_contents.order_id = orders.id").
    where(["product_id = :product_id", {product_id: @product.id}]).count
    @carts_in = Order.where("orders.checkout_date is null").
    joins("JOIN order_contents ON order_contents.order_id = orders.id").
    where(["product_id = :product_id", {product_id: @product.id}]).count
  end

  # GET /products/new
  def new
    @product = Product.new
    @categories_ordered = Category.order(:name)
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy!
    redirect_to products_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :price, :category_id, :sku)
    end
end
