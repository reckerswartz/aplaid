class ProductsController < ApplicationController
  def index
  end

  def show
    #/item/get
    # Retrieve an Item
    #
    # Use the /item/get endpoint to retrieve an Item. The returned Item object contains information about the Item,
    # including available products, webhook information, and the institution ID.
    #
    # Parameters
    # access_token (string) – The access_token associated with the Item to retrieve.

    # check all required params are present

    if params[:id].blank?
      render json: {error: "Missing required params"}, status: :bad_request
      return
    end

    response = PLAID_CLIENT.item_get(
      access_token: params[:id]
    )

    render json: response.to_hash.merge({accounts_url: accounts_product_path(params[:id])})
  end

  def create
    #/sandbox/public_token/create
    # Create a test Item
    #
    # Use the /sandbox/public_token/create endpoint to create a valid public_token for an arbitrary institution ID,
    # initial products, and test credentials. The created public_token maps to a new Sandbox Item.
    # You can then call /item/public_token/exchange to exchange the public_token for an access_token and
    # perform all API actions. /sandbox/public_token/create can also be used with the user_custom test username
    # to generate a test account with custom data. /sandbox/public_token/create cannot be used with OAuth institutions.
    #
    # Parameters
    # institution_id (string) – The ID of the institution to create a test Item for. This can be found in the /institutions/all endpoint.
    # initial_products (array) – The products to create a test Item for. This can be found in the /institutions/all endpoint.
    # public_token (string) – The public_token to exchange for an access_token.

    # check all required params are present
    if create_params[:institution_id].blank? || create_params[:initial_products].blank?
      render json: {error: "Missing required params"}, status: :bad_request
      return
    end

    # Response
    # public_token (string) – The public_token to exchange for an access_token.
    #
    # Example
    # Request
    #
    # curl -X POST \
    #   https://sandbox.plaid.com/sandbox/public_token/create \
    #   -H 'Content-Type: application/json' \
    #   -H 'Postman-Token
    #   -H 'cache-control: no-cache' \
    #  -d '{ "institution_id": "ins_109508", "initial_products": ["transactions"], "options": { "webhook": "https://www.example.com" }, "credentials
    #   "username": "user_good", "password": "pass_good" } }'

    public_token_response = PLAID_CLIENT.sandbox_public_token_create(
      institution_id: create_params[:institution_id],
      initial_products: create_params[:initial_products].split(','),
    )

    #/item/public_token/exchange
    # Exchange a Link public_token for an API access_token

    access_token_response = PLAID_CLIENT.item_public_token_exchange(
      public_token: public_token_response.public_token
    )

    redirect_to product_path(access_token_response.access_token)
  end

  def accounts
    #/accounts/get
    # Retrieve an Item's accounts
    #
    # Use the /accounts/get endpoint to retrieve an Item's accounts. The returned Account objects contain information
    # about the accounts, including balances, names, and numbers.
    #
    # Parameters
    # access_token (string) – The access_token associated with the Item whose accounts to retrieve.

    # check all required params are present

    if params[:id].blank?
      render json: {error: "Missing required params"}, status: :bad_request
      return
    end

    response = PLAID_CLIENT.accounts_get(
      access_token: params[:id]
    )

    render json: response
  end

  private

  def create_params
    params.require(:product).permit(:institution_id, :initial_products, :options, :username, :password)
  end
end
