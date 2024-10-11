const axios = require('axios');

const fetchDataAndSendToNewRelic = async () => {
  try {
    // Fetching data from the API (replace with your actual API endpoint)
    const response = await axios.get('https://api.github.com/orgs/xxx/copilot/usage', {
        headers: {
        'Accept': 'application/vnd.github+json',
        'Authorization': 'Bearer xxxx',
        'X-GitHub-Api-Version': '2022-11-28'
      }
    });

    // Data received from the API (array of daily records)
    const copilotData = response.data;

    // Add the "eventType" dynamically for each record
    const modifiedData = copilotData.map(record => ({
      ...record, // Spread the existing record fields
      eventType: "CopilotUsage" // Add the eventType field
    }));

    //console.log(JSON.stringify(modifiedData, null, 2));

    //Send each record to New Relic
    for (const record of modifiedData) {
      await axios.post('https://insights-collector.newrelic.com/v1/accounts/<accountnumber>/events', record, {
        headers: {
          'Content-Type': 'application/json',
          'X-Insert-Key': '<your ingest key>'
        }
      });
      console.log(`Data for ${record.day} sent to New Relic successfully.`);
    }

  } catch (error) {
    console.error('Error fetching or sending data:', error);
  }
};

// Call the function to fetch and send the data
fetchDataAndSendToNewRelic();
