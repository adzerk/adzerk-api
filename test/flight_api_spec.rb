require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Flight API" do


  before(:all) do
    new_advertiser = {
      'Title' => "Test"
    }
    client = Adzerk::Client.new(API_KEY)
    @flights= client.flights
    @advertisers = client.advertisers
    @channels = client.channels
    @campaigns = client.campaigns
    @priorities = client.priorities

    advertiser = @advertisers.create(:title => "test")
    $advertiserId = advertiser[:id].to_s

    channel = @channels.create(:title => 'Test Channel ' + rand(1000000).to_s,
                               :commission => '0.0',
                               :engine => 'CPM',
                               :keywords => 'test',
                               'CPM' => '10.00',
                               :ad_types =>  [1,2,3,4])
    $channel_id = channel[:id].to_s

    priority = @priorities.create(:name => "High Priority Test",
                                  :channel_id => $channel_id,
                                  :weight => 1,
                                  :is_deleted => false)
    $priority_id = priority[:id].to_s
 
    campaign = @campaigns.
      create(:name => 'Test campaign ' + rand(1000000).to_s,
             :start_date => "1/1/2011",
             :end_date => "12/31/2011",
             :is_active => false,
             :price => '10.00',
             :advertiser_id => $advertiserId,
             :flights => [],
             :is_deleted => false)
    $campaign_id = campaign[:id]

  end

  it "should create a flight" do
    $flight_Name = 'Test flight ' + rand(1000000).to_s
    $flight_StartDate = "1/1/2011"
    $flight_EndDate = "12/31/2011"
    $flight_NoEndDate = false
    $flight_Price = '15.00'
    $flight_OptionType = 1
    $flight_Impressions = 10000
    $flight_IsUnlimited = false
    $flight_IsFullSpeed = false
    $flight_Keywords = "test, test2"
    $flight_UserAgentKeywords = nil
    $flight_WeightOverride = nil
    $flight_CampaignId = $campaign_id
    $flight_IsActive = true
    $flight_IsDeleted = false

    new_flight = {
      :no_end_date => false,
      :priority_id => $priority_id,
      :name => $flight_Name,
      :start_date => $flight_StartDate,
      :end_date => $flight_EndDate,
      :no_end_date => $flight_NoEndDate,
      :price => $flight_Price,
      :option_type => $flight_OptionType,
      :impressions => $flight_Impressions,
      :is_unlimited => $flight_IsUnlimited,
      :is_full_speed => $flight_IsFullSpeed,
      :keywords => $flight_Keywords,
      :user_agent_keywords => $flight_UserAgentKeywords,
      :weight_override => $flight_WeightOverride,
      :campaign_id => $flight_CampaignId,
      :is_active => $flight_IsActive,
      :is_deleted => $flight_IsDeleted
    }
    flight = @flights.create(new_flight)
    $flight_id = flight[:id].to_s
    flight[:no_end_date].should eq(false)
    flight[:priority_id].should eq($priority_id.to_i)
    flight[:name].should eq($flight_Name)
    # JSON.parse(response.body)["StartDate"].should == "/Date(1293840000000+0000)/"
    # JSON.parse(response.body)["EndDate"].should == "/Date(1325307600000-0500)/"
    flight[:price].should eq(15.0)
    flight[:option_type].should eq($flight_OptionType)
    flight[:impressions].should eq($flight_Impressions)
    flight[:is_unlimited].should eq($flight_IsUnlimited)
    flight[:is_full_speed].should eq($flight_IsFullSpeed)
    flight[:keywords].should eq($flight_Keywords)
    flight[:user_agent_keywords].should eq($flight_UserAgentKeywords)
    flight[:weight_override].should eq($flight_WeightOverride)
    flight[:campaign_id].should eq($flight_CampaignId)
    flight[:is_active].should eq($flight_IsActive)
    flight[:is_deleted].should eq($flight_IsDeleted)
  end

  it "should list a specific flight" do
    flight = @flights.get($flight_id)
    flight[:priority_id].should eq($priority_id.to_i)
    flight[:name].should eq($flight_Name)
    flight[:price].should eq(15.0)
    flight[:option_type].should eq($flight_OptionType)
    flight[:impressions].should eq($flight_Impressions)
    flight[:is_unlimited].should eq($flight_IsUnlimited)
    flight[:is_full_speed].should eq($flight_IsFullSpeed)
    flight[:keywords].should eq($flight_Keywords)
    flight[:user_agent_keywords].should eq($flight_UserAgentKeywords)
    flight[:weight_override].should eq($flight_WeightOverride)
    flight[:campaign_id].should eq($flight_CampaignId)
    flight[:is_active].should eq($flight_IsActive)
    flight[:is_deleted].should eq($flight_IsDeleted)
  end

  it "should update a flight" do
    flight = @flights.update(:id => $flight_id,
                             :campaign_id => $flight_CampaignId,
                             :name => "New Flight Name",
                             :priority_id => $priority_id)
    flight[:name].should eq("New Flight Name")
  end

  it "should list all flights" do
    flights = @flights.list
    flights.length.should > 0
  end

  it "should delete a new flight" do
    response = @flights.delete($flight_id)
    response.body.should == 'OK'
  end

  it "should create a flight with geotargeting" do
    geo = [{
      'CountryCode' => 'US',
      'Region' => 'NC',
      'MetroCode' => '560'
    }]

    new_flight = {
      'NoEndDate' => false,
      'PriorityId' => $priority_id,
      'Name' => $flight_Name,
      'StartDate' => $flight_StartDate,
      'EndDate' => $flight_EndDate,
      'NoEndDate' => $flight_NoEndDate,
      'Price' => $flight_Price,
      'OptionType' => $flight_OptionType,
      'Impressions' => $flight_Impressions,
      'IsUnlimited' => $flight_IsUnlimited,
      'IsFullSpeed' => $flight_IsFullSpeed,
      'Keywords' => $flight_Keywords,
      'UserAgentKeywords' => $flight_UserAgentKeywords,
      'WeightOverride' => $flight_WeightOverride,
      'CampaignId' => $flight_CampaignId,
      'IsActive' => $flight_IsActive,
      'IsDeleted' => $flight_IsDeleted,
      'GeoTargeting' => geo
    }
    flight = @flights.create(new_flight)
    $flight_id = flight[:id].to_s
    flight[:no_end_date].should eq(false)
    flight[:priority_id].should eq($priority_id.to_i)
    flight[:name].should eq($flight_Name)
    # JSON.parse(response.body)["StartDate"].should == "/Date(1293840000000+0000)/"
    # JSON.parse(response.body)["EndDate"].should == "/Date(1325307600000-0500)/"
    flight[:price].should eq(15.0)
    flight[:option_type].should eq($flight_OptionType)
    flight[:impressions].should eq($flight_Impressions)
    flight[:is_unlimited].should eq($flight_IsUnlimited)
    flight[:is_full_speed].should eq($flight_IsFullSpeed)
    flight[:keywords].should eq($flight_Keywords)
    flight[:user_agent_keywords].should eq($flight_UserAgentKeywords)
    flight[:weight_override].should eq($flight_WeightOverride)
    flight[:campaign_id].should eq($flight_CampaignId)
    flight[:is_active].should eq($flight_IsActive)
    flight[:is_deleted].should eq($flight_IsDeleted)
    geotargeting = flight[:geo_targeting].first
    geotargeting[:country_code].should eq("US")
    geotargeting[:region].should eq("NC")
    geotargeting[:metro_code].should eq(560)
  end
end
