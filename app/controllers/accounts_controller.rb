class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy, :transfer, :deposit, :withdraw]

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = Account.all
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)

    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def deposit
    command = DepositCommand.new(params[:id], params[:amount])
    if command.valid?
      command.perform
      CUSTOM_LOGGER.info("Deposit: "+ params[:amount] + " in Account:" + params[:id] )
    else
      CUSTOM_LOGGER.error("Deposit: "+ params[:amount] + " in Account:" + params[:id] )
    end
    redirect_to @account, notice: "Crédito no valor #{params[:amount]} para a conta #{params[:id]} realizado com sucesso."
  end

  def withdraw
    command = WithdrawCommand.new(params[:id], params[:amount])
    if command.valid?
      command.perform
      CUSTOM_LOGGER.info("Withdraw: "+ params[:amount] + " in Account:" + params[:id] )
    else
      CUSTOM_LOGGER.error("Withdraw: "+ params[:amount] + " in Account:" + params[:id] )
    end
    redirect_to @account, notice: "Débito no valor #{params[:amount]} para a conta #{params[:id]} realizado com sucesso"
  end

  def transfer
    source_command = WithdrawCommand.new(params[:id], params[:amount])
    target_command = DepositCommand.new(params[:target], params[:amount])
    if source_command.valid? && target_command.valid? && Account.all.collect(&:id).include?(params[:target].to_i)
      source_command.perform
      target_command.perform
      CUSTOM_LOGGER.info("Transfer: "+ params[:amount] + " from Account:" + params[:id] + " to Account:" + params[:target] )
    else
      CUSTOM_LOGGER.error("Transfer: "+ params[:amount] + " from Account:" + params[:id] + " to Account:" + params[:target] )
    end
    redirect_to @account
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:balance)
    end
end
