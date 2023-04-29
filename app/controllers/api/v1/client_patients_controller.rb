# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::ClientPatientsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :client_patient, through: :team, through_association: :client_patients

    # GET /api/v1/teams/:team_id/client_patients
    def index
    end

    # GET /api/v1/client_patients/:id
    def show
    end

    # POST /api/v1/teams/:team_id/client_patients
    def create
      if @client_patient.save
        render :show, status: :created, location: [:api, :v1, @client_patient]
      else
        render json: @client_patient.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/client_patients/:id
    def update
      if @client_patient.update(client_patient_params)
        render :show
      else
        render json: @client_patient.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/client_patients/:id
    def destroy
      @client_patient.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def client_patient_params
        strong_params = params.require(:client_patient).permit(
          *permitted_fields,
          :first_name,
          :last_name,
          :middle_name,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::ClientPatientsController
  end
end
