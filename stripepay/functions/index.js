const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

const firestore = admin.firestore();
const settings = { timestampInSnapshots: true };
firestore.settings(settings);

//const stripe = require('stripe')(functions.config().stripe.token);

var stripe = require("stripe")("sk_test_qB1nqkICI1qTMBgkVirAEnpu00eYrxaqQR");

exports.addStripeSource = functions.firestore.document('cards/{userid}/tokens/{tokenid}').onCreate(async (tokenSnap, context) => {
        var customer;
        var data = tokenSnap.data();
        if (data === null) {
                return null;
        }
        const token = data.tokenid;


        const snapshot = await firestore.collection('cards').doc(context.params.userid).get();//this will be the userID from cards doc in firestore
        console.log(".5");
        const customerId = snapshot.data().custId;
        console.log(".66");
        const customerEmail = snapshot.data().email;
        console.log(".77");
        console.log(customerId);
        //if (customerId === 'new') {
        console.log("1");
        customer = await stripe.customers.create({
                email: customerEmail,
                source: token
        });
        console.log("2");
        firestore.collection('cards').doc(context.params.userid).update({
                custId: customer.id //this is updating customerId in firestore
        });
        console.log("3");
        //}
        // else {
        //        customer = await stripe.customers.retrieve(customerId);
        // }
        console.log("4");
        console.log(customer.sources)
        const customerSource = customer.sources.data[0];
        console.log("5");
        console.log(customerSource);
        return firestore.collection('cards').doc(context.params.userid).collection('sources').doc(customerSource.card.fingerprint).set(customerSource, { merge: true });
})







