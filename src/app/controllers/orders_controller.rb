class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  def purchase
    if params[:commit] === "buy"
      buy params[:amount], params["product_id"]
    elsif params[:commit] === "put in cart"
      put_in_cart params[:amount], params["product_id"]
    end
  end

  def buy amount, product_id
    product = Product.find product_id
    total_price = amount.to_d * product[:price].to_d
    @order_param = {amount: amount, total_price: total_price.to_s}
    attributes = {buyer_id: current_user.id, seller_id: product.seller_id, status: "unpaid", total_price: total_price}
    # @order = Order.new attributes
    render :buy
  end

  def put_in_cart
    
  end

  # POST /orders
  # POST /orders.json
  def create
    puts "<<<<<<<<<<<" + order_params.to_s
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:buyer_id, :seller_id, :status, :total_price, :postcode, :address, :phone)
    end
end
