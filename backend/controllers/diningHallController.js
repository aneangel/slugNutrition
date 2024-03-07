const express = require('express');
const router = express.Router();
const db = admin.firestore();

router.get('/menus/:diningHall', async (req, res) => {
  try {
    const diningHallId = req.params.diningHall;
    const doc = await db.collection('Dining Hall Menus').doc(diningHallId).get();

    if (!doc.exists) {
      return res.status(404).send('Dining Hall not found');
    }

    return res.status(200).json(doc.data());
  } catch (error) {
    return res.status(500).send(error.toString());
  }
});
