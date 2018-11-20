class UsersController < ApplicationController
# the user clears cart when they buy or manually delete the cart
helper_method :add_cart
before_action :require_login
skip_before_action :require_login, only: [:welcome, :buy_or_sell, :new, :create]


  def welcome
  end

  def buy_or_sell
  end

  def add_cart
    sum = 0;
  #want to byebug to actually see what is happening here
    current_cart.each do |productObj|
        sum += productObj['price'] * productObj['quantity'].to_i
    end

    sum
  end

  def delete_cart
    current_cart.each do |cartItem|
      found_user_product = UserProduct.find_by(product_id: cartItem['product_id'], user_id: cartItem['user_id'])
      seller_quantity = found_user_product.quantity
      new_quantity = found_user_product.quantity + cartItem['quantity']
      found_user_product.update(quantity: new_quantity)
    end
   current_cart.clear
   redirect_to root_path
  end

  def show
    @user = User.find(params[:id])
    @cart = current_cart
    @array_products = []
    @cart.each do |cartItem|
      product = UserProduct.find_by(product_id: cartItem['product_id'])
      @array_products << product
    end
    @cart_total = add_cart
  end

  def checkout
   balance = current_user.bank_account.to_i
     if balance >= add_cart
       monies = current_user.bank_account.to_i
       monies -= add_cart
       current_user.update(bank_account: monies)

       current_cart.each do |cartObj|
         product_id = cartObj["product_id"]
         user_product_obj = UserProduct.find_by(product_id: product_id)
         seller = User.find(user_product_obj["user_id"])
         seller_monies = seller.bank_account.to_i
         seller_monies += user_product_obj.price * cartObj["quantity"]
         seller.update(bank_account: seller_monies)
       end

       current_cart.clear
       flash[:notice] = "Your purchase has been successfully completed. Thank you for shopping at Manuela's!"
       redirect_to root_path
     else
       flash[:notice] = "You don't have enough money in your bank account."
       redirect_to user_path(current_user)
     end
 end

  def confirmation
    render :confirmation
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      redirect_to login_path
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    byebug
    if @user.valid?
      redirect_to user_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end

  private

  def user_params
    #add the image later
    params.require(:user).permit(:first_name, :last_name,:user_name, :password, :password_confirmation, :email, :address, :bank_account)
  end

end
