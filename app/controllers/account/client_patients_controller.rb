class Account::ClientPatientsController < Account::ApplicationController
  account_load_and_authorize_resource :client_patient, through: :team, through_association: :client_patients

  # GET /account/teams/:team_id/client_patients
  # GET /account/teams/:team_id/client_patients.json
  def index
    delegate_json_to_api
  end

  # GET /account/client_patients/:id
  # GET /account/client_patients/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/client_patients/new
  def new
  end

  # GET /account/client_patients/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/client_patients
  # POST /account/teams/:team_id/client_patients.json
  def create
    respond_to do |format|
      if @client_patient.save
        format.html { redirect_to [:account, @client_patient], notice: I18n.t("client_patients.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @client_patient] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client_patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/client_patients/:id
  # PATCH/PUT /account/client_patients/:id.json
  def update
    respond_to do |format|
      if @client_patient.update(client_patient_params)
        format.html { redirect_to [:account, @client_patient], notice: I18n.t("client_patients.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @client_patient] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client_patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/client_patients/:id
  # DELETE /account/client_patients/:id.json
  def destroy
    @client_patient.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :client_patients], notice: I18n.t("client_patients.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
