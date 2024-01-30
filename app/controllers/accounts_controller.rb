class AccountsController < ApplicationController
    def show
        @account_holder = User.find(params[:id])
    end

    def edit
        @account_holder = User.find(params[:id])
    end

    def update
        @account_holder = User.find(params[:id])
        if @account_holder.update(account_params)
          redirect_to account_path(@account_holder) , notice: 'Account was successfully updated.'
        else
          render :edit
        end
    end
    
    private
    def account_params
        params.require(:user).permit( :email, :full_name, :date_of_birth, :gender)
    end
end
