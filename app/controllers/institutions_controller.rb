class InstitutionsController < ApplicationController
  def index
    # /institutions/all
    # Retrieve all institutions
    #
    # Use the /institutions/get endpoint to retrieve all institutions. The returned array contains information about
    # each institution, including the institution ID, name, and products.
    #
    # Parameters
    # count (integer) – The number of institutions to return. The maximum is 500.
    # offset (integer) – The number of institutions to skip before returning results.
    # country_codes (array) – An array of country codes to filter institutions by.
    # The country codes are ISO 3166-1 alpha-2 country codes.

    # set default params
    params[:count] ||= 500
    params[:offset] ||= 0
    params[:country_codes] ||= ["US"]

    response = PLAID_CLIENT.institutions_get(
      count: params[:count],
      offset: params[:offset],
      country_codes: params[:country_codes]
    )

    render json: response
  end

  def show
    #/institutions/get_by_id
    # Retrieve an institution by ID
    #
    # Use the /institutions/get_by_id endpoint to retrieve an institution by its ID. The returned institution object
    # contains information about the institution, including the institution ID, name, and products.
    #
    # Parameters
    # institution_id (string) – The ID of the institution to retrieve. This can be found in the /institutions/all endpoint.

    # check all required params are present
    if show_params[:institution_id].blank?
      render json: {error: "Missing required params"}, status: :bad_request
      return
    end

    response = PLAID_CLIENT.institutions_get_by_id(
      institution_id: params[:id]
    )

    render json: response
  end
end
