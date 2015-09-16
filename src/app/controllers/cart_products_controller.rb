class CartProductsController < ApplicationController
  before_action :set_cart_product, only: [:show, :edit, :update, :destroy]
  # GET /cart_products
  # GET /cart_products.json
  def index
    @cart_products = CartProduct.all
  end

  # GET /cart_products/1
  # GET /cart_products/1.json
  def show
    @product = Product.find @cart_product.product_id
  end

  # show all products in the cart of the current user
  def show_cart
    @show_cart_list = CartProduct.show_cart(params[:page], current_user.id )
  end

  # put a new product in the cart
  def new
    request_amount = params["amount"].to_i
    @product = Product.find params["productId"]
    product_quantity = @product.quantity

    if(CartProduct.ifSameProductExist(params["productId"], current_user.id))
      existedCartProduct = CartProduct.ifSameProductExist(params["productId"],current_user.id)
      if existedCartProduct.quantity+request_amount > product_quantity
        flash[:notice] = 'Sorry, the quantity of the product insufficient.'
        redirect_to @product
      end
      newquantity = existedCartProduct.quantity + request_amount
      existedCartProduct.update_attributes!(quantity: newquantity)
      # existedCartProduct.quantity += params["amount"].to_i
      # existedCartProduct.save!
      flash[:notice] = 'Cart product was successfully created.'
      redirect_to  existedCartProduct
    else
      if request_amount > product_quantity
        flash[:notice] = 'Sorry, the quantity of the product insufficient.'
        redirect_to @product
      end
      @product_params = {quantity: params["amount"], product_id: params["productId"]}
      @cart_product = CartProduct.new @product_params
      current_user.cart_products << @cart_product
      @cart_product.save!
      flash[:notice] = 'Cart product was successfully created.'
      redirect_to  @cart_product
    end
  end

  # GET /cart_products/1/edit
  def edit
  end

  # POST /cart_products
  # POST /cart_products.json
  def create
    @cart_product = CartProduct.new(cart_product_params)

    respond_to do |format|
      if @cart_product.save
        format.html { redirect_to @cart_product, notice: 'Cart product was successfully created.' }
        format.json { render :show, status: :created, location: @cart_product }
      else
        format.html { render :new }
        format.json { render json: @cart_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cart_products/1
  # PATCH/PUT /cart_products/1.json
  def update
    request_amount = params["amount"].to_i
    @product = Product.find params["productId"]
    product_quantity = @product.quantity
    respond_to do |format|
      if @cart_product.update(cart_product_params)
        format.html { redirect_to @cart_product, notice: 'Cart product was successfully updated.' }
        format.json { render :show, status: :ok, location: @cart_product }
      else
        format.html { render :edit }
        format.json { render json: @cart_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cart_products/1
  # DELETE /cart_products/1.json
  # delete one product from the cart
  def destroy

    @cart_product = CartProduct.find(params[:id])

    @cart_product.destroy
    flash[:notice] = 'The product has been deleted from the cart.'
    redirect_to :controller => 'cart_products', :action => 'show_cart'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart_product
      @cart_product = CartProduct.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_product_params
      params.require(:cart_product).permit(:cart_id, :product_id, :quantity)
    end
end
