// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { firebaseConfigKeys } from "/firebaseConfigKeys"
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
    apiKey: firebaseConfigKeys.apiKey,
    authDomain: firebaseConfigKeys.authDomain,
    projectId: firebaseConfigKeys.projectId,
    storageBucket: firebaseConfigKeys.storageBucket,
    messagingSenderId: firebaseConfigKeys.messagingSenderId,
    appId: firebaseConfigKeys.appId,
    measurementId: firebaseConfigKeys.measurementId
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);