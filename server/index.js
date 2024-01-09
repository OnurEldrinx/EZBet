const { MongoClient } = require('mongodb');
const express = require('express');
const axios = require('axios');

let client;
const uri = 'mongodb://localhost:27017';
const apiUrl = 'https://www.nosyapi.com/apiv2/bets/getMatches';
const params = { t: '2023-11-04',lig:'TR' };
const headers = {
    'Content-Type': 'application/json',
    'Authorization': 'API'
  };
const dbName = 'iddia';
const app = express();
const port = 3000;
app.use(express.json());


// retrieve games from api and send them to db

/* axios.get(apiUrl, { params, headers })
  .then(async response => {
    const gamesData = response.data.data;

    client = await MongoClient.connect(uri);    
    const db = client.db(dbName);
    const gamesCollection = db.collection('games');

    await gamesCollection.insertMany(gamesData);

    
    client.close();
  })
  .catch(error => {
    console.error('Error:', error);
  });
 */





  // retrieve games from database
  app.get('/api/games', async (req, res) => {
    try {
      client = await MongoClient.connect(uri);
      const db = client.db(dbName);
      const gamesCollection = db.collection('games');
  
      const games = await gamesCollection.find({}).toArray();
      console.log(games);
  
      res.json(games);
    } catch (error) {
      console.error('Error:', error);
      return res.status(500).json({ error: 'Error' });
    } finally {
      client.close();
    }
  });
  



 // root url 
app.get('/', (req, res) => {
  res.send('a');
});


// register
app.post('/api/register', async (req, res) => {
  try {

    const { username, password } = req.body;
    
    client = await MongoClient.connect(uri);    
    const db = client.db(dbName);
    const usersCollection = db.collection('users');
    
    const newUser = {
      username,
      password,
    };
    console.log('New User Data:', newUser);
    const result = await usersCollection.insertOne(newUser);
    console.log('Insert Result:', result);
    
    res.json(result);
  } catch (error) {
    console.log('Error:', error);
    return res.status(500).json({ error: 'Error' });
  } finally {
    client.close();
  }
});


// login
app.post('/api/login', async (req, res) => {
  try {
    const { username, password } = req.body;
    
    client = await MongoClient.connect(uri);    
    const db = client.db(dbName);
    const usersCollection = db.collection('users');
    
    const user = await usersCollection.findOne({ username, password });
    
    if (user) {
      res.json({ message: 'Login successful' });
    } else {
      res.status(401).json({ error: 'Invalid credentials' });
    }
  } catch (error) {
    console.log('Error:', error);
    return res.status(500).json({ error: 'Error' });
  } finally {
    client.close();
  }
});


// save coupons to db
app.post('/api/savedCoupons', async (req, res) => {
  console.log("Reveived data: ", req.body);
  try {
    const data = req.body; 

    client = await MongoClient.connect(uri);
    const db = client.db(dbName);
    const savedCouponsCollection = db.collection('savedCoupons');

    const result = await savedCouponsCollection.insertOne(data);

    res.status(200).json({ message: 'Data saved ', result });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: '  Error' });
  } finally {
    client && client.close();
  }
});

// retrieve saved coupons from db
app.get('/api/savedCoupons/:username', async (req, res) => {
  try {
    const username = req.params.username;
    client = await MongoClient.connect(uri);
    const db = client.db(dbName);
    const savedCouponsCollection = db.collection('savedCoupons');

    const coupons = await savedCouponsCollection.find({ username: username }).toArray();

    res.status(200).json(coupons);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  } finally {
    client && client.close();
  }
});



    


app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
