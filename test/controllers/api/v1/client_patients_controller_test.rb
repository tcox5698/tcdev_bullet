require "controllers/api/v1/test"

class Api::V1::ClientPatientsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @client_patient = build(:client_patient, team: @team)
    @other_client_patients = create_list(:client_patient, 3)

    @another_client_patient = create(:client_patient, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @client_patient.save
    @another_client_patient.save
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(client_patient_data)
    # Fetch the client_patient in question and prepare to compare it's attributes.
    client_patient = ClientPatient.find(client_patient_data["id"])

    assert_equal_or_nil client_patient_data['first_name'], client_patient.first_name
    assert_equal_or_nil client_patient_data['last_name'], client_patient.last_name
    assert_equal_or_nil client_patient_data['middle_name'], client_patient.middle_name
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal client_patient_data["team_id"], client_patient.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/client_patients", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    client_patient_ids_returned = response.parsed_body.map { |client_patient| client_patient["id"] }
    assert_includes(client_patient_ids_returned, @client_patient.id)

    # But not returning other people's resources.
    assert_not_includes(client_patient_ids_returned, @other_client_patients[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/client_patients/#{@client_patient.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/client_patients/#{@client_patient.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    client_patient_data = JSON.parse(build(:client_patient, team: nil).to_api_json.to_json)
    client_patient_data.except!("id", "team_id", "created_at", "updated_at")
    params[:client_patient] = client_patient_data

    post "/api/v1/teams/#{@team.id}/client_patients", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/client_patients",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/client_patients/#{@client_patient.id}", params: {
      access_token: access_token,
      client_patient: {
        first_name: 'Alternative String Value',
        last_name: 'Alternative String Value',
        middle_name: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @client_patient.reload
    assert_equal @client_patient.first_name, 'Alternative String Value'
    assert_equal @client_patient.last_name, 'Alternative String Value'
    assert_equal @client_patient.middle_name, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/client_patients/#{@client_patient.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("ClientPatient.count", -1) do
      delete "/api/v1/client_patients/#{@client_patient.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/client_patients/#{@another_client_patient.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
