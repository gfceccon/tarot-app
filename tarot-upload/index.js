import { initializeApp } from "firebase/app";
import { getFirestore, collection, getDocs, doc, writeBatch } from 'firebase/firestore/lite';
import { getAuth, createUserWithEmailAndPassword, signInWithEmailAndPassword } from "firebase/auth";

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "",
  authDomain: "",
  projectId: "",
  storageBucket: "",
  messagingSenderId: "",
  appId: ""
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
let user;

const email = ''; // Insert email here
const password = ''; // Insert password here


await createUserWithEmailAndPassword(auth, email, password)
  .then((userCredential) => {
    // Signed in 
    user = userCredential.user;
    console.log(user);
  })
  .catch((error) => {
    const errorCode = error.code;
    const errorMessage = error.message;
    console.log(errorCode, errorMessage);
    
    // Try to login otherwise
    return signInWithEmailAndPassword(auth, email, password);
  }).then((userCredential) => {
    // Login
    user = userCredential.user;
    console.log(user);
  }).catch((error) => {
    // Error both sign and login
    const errorCode = error.code;
    const errorMessage = error.message;
    console.log(errorCode, errorMessage);
    process.exit();
  });

// Tarot cards
var cards = [
  ["major_00_the_fool", "major", "The Fool", "assets/images/tarot/major/major_00_the_fool.jpg", "innocence, new beginnings, free spirit", "recklessness, taken advantage of, inconsideration"],
  ["major_01_the_magician", "major", "The Magician", "assets/images/tarot/major/major_01_the_magician.jpg", "willpower, desire, creation, manifestation", "trickery, illusions, out of touch"],
  ["major_02_the_high_priestess", "major", "The High Priestess", "assets/images/tarot/major/major_02_the_high_priestess.jpg", "intuitive, unconscious, inner voice", "lack of center, lost inner voice, repressed feelings"],
  ["major_03_the_empress", "major", "The Empress", "assets/images/tarot/major/major_03_the_empress.jpg", "motherhood, fertility, nature", "dependence, smothering, emptiness, nosiness"],
  ["major_04_the_emperor", "major", "The Emperor", "assets/images/tarot/major/major_04_the_emperor.jpg", "authority, structure, control, fatherhood", "tyranny, rigidity, coldness"],
  ["major_05_the_hierophant", "major", "The Hierophant", "assets/images/tarot/major/major_05_the_hierophant.jpg", "tradition, conformity, morality, ethics", "rebellion, subversiveness, new approaches"],
  ["major_06_the_lovers", "major", "The Lovers", "assets/images/tarot/major/major_06_the_lovers.jpg", "partnerships, duality, union", "loss of balance, one-sidedness, disharmony"],
  ["major_07_the_chariot", "major", "The Chariot", "assets/images/tarot/major/major_07_the_chariot.jpg", "direction, control, willpower", "lack of control, lack of direction, aggression"],
  ["major_08_strength", "major", "Strength", "assets/images/tarot/major/major_08_strength.jpg", "inner strength, bravery, compassion, focus", "self doubt, weakness, insecurity"],
  ["major_09_the_hermit", "major", "The Hermit", "assets/images/tarot/major/major_09_the_hermit.jpg", "contemplation, search for truth, inner guidance", "loneliness, isolation, lost your way"],
  ["major_10_wheel_of_fortune", "major", "Wheel of Fortune", "assets/images/tarot/major/major_10_wheel_of_fortune.jpg", "change, cycles, inevitable fate", "no control, clinging to control, bad luck"],
  ["major_11_justice", "major", "Justice", "assets/images/tarot/major/major_11_justice.jpg", "cause and effect, clarity, truth", "dishonesty, unaccountability, unfairness"],
  ["major_12_the_hanged_man", "major", "The Hanged Man", "assets/images/tarot/major/major_12_the_hanged_man.jpg", "sacrifice, release, martyrdom", "stalling, needless sacrifice, fear of sacrifice"],
  ["major_13_death", "major", "Death", "assets/images/tarot/major/major_13_death.jpg", "end of cycle, beginnings, change, metamorphosis", "fear of change, holding on, stagnation, decay"],
  ["major_14_temperance", "major", "Temperance", "assets/images/tarot/major/major_14_temperance.jpg", "middle path, patience, finding meaning", "extremes, excess, lack of balance"],
  ["major_15_the_devil", "major", "The Devil", "assets/images/tarot/major/major_15_the_devil.jpg", "addiction, materialism, playfulness", "freedom, release, restoring control"],
  ["major_16_the_tower", "major", "The Tower", "assets/images/tarot/major/major_16_the_tower.jpg", "sudden upheaval, broken pride, disaster", "disaster avoided, delayed disaster, fear of suffering"],
  ["major_17_the_star", "major", "The Star", "assets/images/tarot/major/major_17_the_star.jpg", "hope, faith, rejuvenation", "faithlessness, discouragement, insecurity"],
  ["major_18_the_moon", "major", "The Moon", "assets/images/tarot/major/major_18_the_moon.jpg", "unconscious, illusions, intuition", "confusion, fear, misinterpretation"],
  ["major_19_the_sun", "major", "The Sun", "assets/images/tarot/major/major_19_the_sun.jpg", "joy, success, celebration, positivity", "negativity, depression, sadness"],
  ["major_20_judgment", "major", "Judgment", "assets/images/tarot/major/major_20_judgment.jpg", "reflection, reckoning, awakening", "lack of self awareness, doubt, self loathing"],
  ["major_21_the_world", "major", "The World", "assets/images/tarot/major/major_21_the_world.jpg", "fulfillment, harmony, completion", "incompletion, no closure"],
  ["wands_01", "wands", "Ace of Wands", "assets/images/tarot/wands/wands_01.jpg", "creation, willpower, inspiration, desire", "lack of energy, lack of passion, boredom"],
  ["wands_02", "wands", "Two of Wands", "assets/images/tarot/wands/wands_02.jpg", "planning, making decisions, leaving home", "fear of change, playing safe, bad planning"],
  ["wands_03", "wands", "Three of Wands", "assets/images/tarot/wands/wands_03.jpg", "looking ahead, expansion, rapid growth", "obstacles, delays, frustration"],
  ["wands_04", "wands", "Four of Wands", "assets/images/tarot/wands/wands_04.jpg", "community, home, celebration", "lack of support, transience, home conflicts"],
  ["wands_05", "wands", "Five of Wands", "assets/images/tarot/wands/wands_05.jpg", "competition, rivalry, conflict", "avoiding conflict, respecting differences"],
  ["wands_06", "wands", "Six of Wands", "assets/images/tarot/wands/wands_06.jpg", "victory, success, public reward", "excess pride, lack of recognition, punishment"],
  ["wands_07", "wands", "Seven of Wands", "assets/images/tarot/wands/wands_07.jpg", "perseverance, defensive, maintaining control", "give up, destroyed confidence, overwhelmed"],
  ["wands_08", "wands", "Eight of Wands", "assets/images/tarot/wands/wands_08.jpg", "rapid action, movement, quick decisions", "panic, waiting, slowdown"],
  ["wands_09", "wands", "Nine of Wands", "assets/images/tarot/wands/wands_09.jpg", "resilience, grit, last stand", "exhaustion, fatigue, questioning motivations"],
  ["wands_10", "wands", "Ten of Wands", "assets/images/tarot/wands/wands_10.jpg", "accomplishment, responsibility, burden", "inability to delegate, overstressed, burnt out"],
  ["wands_11_page", "wands", "Page of Wands", "assets/images/tarot/wands/wands_11_page.jpg", "exploration, excitement, freedom", "lack of direction, procrastination, creating conflict"],
  ["wands_12_knight", "wands", "Knight of Wands", "assets/images/tarot/wands/wands_12_knight.jpg", "action, adventure, fearlessness", "anger, impulsiveness, recklessness"],
  ["wands_13_queen", "wands", "Queen of Wands", "assets/images/tarot/wands/wands_13_queen.jpg", "courage, determination, joy", "selfishness, jealousy, insecurities"],
  ["wands_14_king", "wands", "King of Wands", "assets/images/tarot/wands/wands_14_king.jpg", "big picture, leader, overcoming challenges", "impulsive, overbearing, unachievable expectations"],
  ["cups_01", "cups", "Ace of Cups", "assets/images/tarot/cups/cups_01.jpg", "new feelings, spirituality, intuition", "emotional loss, blocked creativity, emptiness"],
  ["cups_02", "cups", "Two of Cups", "assets/images/tarot/cups/cups_02.jpg", "unity, partnership, connection", "imbalance, broken communication, tension"],
  ["cups_03", "cups", "Three of Cups", "assets/images/tarot/cups/cups_03.jpg", "friendship, community, happiness", "overindulgence, gossip, isolation"],
  ["cups_04", "cups", "Four of Cups", "assets/images/tarot/cups/cups_04.jpg", "apathy, contemplation, disconnectedness", "sudden awareness, choosing happiness, acceptance"],
  ["cups_05", "cups", "Five of Cups", "assets/images/tarot/cups/cups_05.jpg", "loss, grief, self-pity", "acceptance, moving on, finding peace"],
  ["cups_06", "cups", "Six of Cups", "assets/images/tarot/cups/cups_06.jpg", "familiarity, happy memories, healing", "moving forward, leaving home, independence"],
  ["cups_07", "cups", "Seven of Cups", "assets/images/tarot/cups/cups_07.jpg", "searching for purpose, choices, daydreaming", "lack of purpose, diversion, confusion"],
  ["cups_08", "cups", "Eight of Cups", "assets/images/tarot/cups/cups_08.jpg", "walking away, disillusionment, leaving behind", "avoidance, fear of change, fear of loss"],
  ["cups_09", "cups", "Nine of Cups", "assets/images/tarot/cups/cups_09.jpg", "satisfaction, emotional stability, luxury", "lack of inner joy, smugness, dissatisfaction"],
  ["cups_10", "cups", "Ten of Cups", "assets/images/tarot/cups/cups_10.jpg", "inner happiness, fulfillment, dreams coming true", "shattered dreams, broken family, domestic disharmony"],
  ["cups_11_page", "cups", "Page of Cups", "assets/images/tarot/cups/cups_11_page.jpg", "happy surprise, dreamer, sensitivity", "emotional immaturity, insecurity, disappointment"],
  ["cups_12_knight", "cups", "Knight of Cups", "assets/images/tarot/cups/cups_12_knight.jpg", "following the heart, idealist, romantic", "moodiness, disappointment"],
  ["cups_13_queen", "cups", "Queen of Cups", "assets/images/tarot/cups/cups_13_queen.jpg", "compassion, calm, comfort", "martyrdom, insecurity, dependence"],
  ["cups_14_king", "cups", "King of Cups", "assets/images/tarot/cups/cups_14_king.jpg", "compassion, control, balance", "coldness, moodiness, bad advice"],
  ["swords_01", "swords", "Ace of Swords", "assets/images/tarot/swords/swords_01.jpg", "breakthrough, clarity, sharp mind", "confusion, brutality, chaos"],
  ["swords_02", "swords", "Two of Swords", "assets/images/tarot/swords/swords_02.jpg", "difficult choices, indecision, stalemate", "lesser of two evils, no right choice, confusion"],
  ["swords_03", "swords", "Three of Swords", "assets/images/tarot/swords/swords_03.jpg", "heartbreak, suffering, grief", "recovery, forgiveness, moving on"],
  ["swords_04", "swords", "Four of Swords", "assets/images/tarot/swords/swords_04.jpg", "rest, restoration, contemplation", "restlessness, burnout, stress"],
  ["swords_05", "swords", "Five of Swords", "assets/images/tarot/swords/swords_05.jpg", "unbridled ambition, win at all costs, sneakiness", "lingering resentment, desire to reconcile, forgiveness"],
  ["swords_06", "swords", "Six of Swords", "assets/images/tarot/swords/swords_06.jpg", "transition, leaving behind, moving on", "emotional baggage, unresolved issues, resisting transition"],
  ["swords_07", "swords", "Seven of Swords", "assets/images/tarot/swords/swords_07.jpg", "deception, trickery, tactics and strategy", "coming clean, rethinking approach, deception"],
  ["swords_08", "swords", "Eight of Swords", "assets/images/tarot/swords/swords_08.jpg", "imprisonment, entrapment, self-victimization", "self acceptance, new perspective, freedom"],
  ["swords_09", "swords", "Nine of Swords", "assets/images/tarot/swords/swords_09.jpg", "anxiety, hopelessness, trauma", "hope, reaching out, despair"],
  ["swords_10", "swords", "Ten of Swords", "assets/images/tarot/swords/swords_10.jpg", "failure, collapse, defeat", "can't get worse, only upwards, inevitable end"],
  ["swords_11_page", "swords", "Page of Swords", "assets/images/tarot/swords/swords_11_page.jpg", "curiosity, restlessness, mental energy", "deception, manipulation, all talk"],
  ["swords_12_knight", "swords", "Knight of Swords", "assets/images/tarot/swords/swords_12_knight.jpg", "action, impulsiveness, defending beliefs", "no direction, disregard for consequences, unpredictability"],
  ["swords_13_queen", "swords", "Queen of Swords", "assets/images/tarot/swords/swords_13_queen.jpg", "complexity, perceptiveness, clear mindedness", "cold hearted, cruel, bitterness"],
  ["swords_14_king", "swords", "King of Swords", "assets/images/tarot/swords/swords_14_king.jpg", "head over heart, discipline, truth", "manipulative, cruel, weakness"],
  ["pentacles_01", "pentacles", "Ace of Pentacles", "assets/images/tarot/pentacles/pentacles_01.jpg", "opportunity, prosperity, new venture", "lost opportunity, missed chance, bad investment"],
  ["pentacles_02", "pentacles", "Two of Pentacles", "assets/images/tarot/pentacles/pentacles_02.jpg", "balancing decisions, priorities, adapting to change", "loss of balance, disorganized, overwhelmed"],
  ["pentacles_03", "pentacles", "Three of Pentacles", "assets/images/tarot/pentacles/pentacles_03.jpg", "teamwork, collaboration, building", "lack of teamwork, disorganized, group conflict"],
  ["pentacles_04", "pentacles", "Four of Pentacles", "assets/images/tarot/pentacles/pentacles_04.jpg", "conservation, frugality, security", "greediness, stinginess, possessiveness"],
  ["pentacles_05", "pentacles", "Five of Pentacles", "assets/images/tarot/pentacles/pentacles_05.jpg", "need, poverty, insecurity", "recovery, charity, improvement"],
  ["pentacles_06", "pentacles", "Six of Pentacles", "assets/images/tarot/pentacles/pentacles_06.jpg", "charity, generosity, sharing", "strings attached, stinginess, power and domination"],
  ["pentacles_07", "pentacles", "Seven of Pentacles", "assets/images/tarot/pentacles/pentacles_07.jpg", "hard work, perseverance, diligence", "work without results, distractions, lack of rewards"],
  ["pentacles_08", "pentacles", "Eight of Pentacles", "assets/images/tarot/pentacles/pentacles_08.jpg", "apprenticeship, passion, high standards", "lack of passion, uninspired, no motivation"],
  ["pentacles_09", "pentacles", "Nine of Pentacles", "assets/images/tarot/pentacles/pentacles_09.jpg", "fruits of labor, rewards, luxury", "reckless spending, living beyond means, false success"],
  ["pentacles_10", "pentacles", "Ten of Pentacles", "assets/images/tarot/pentacles/pentacles_10.jpg", "legacy, culmination, inheritance", "fleeting success, lack of stability, lack of resources"],
  ["pentacles_11_page", "pentacles", "Page of Pentacles", "assets/images/tarot/pentacles/pentacles_11_page.jpg", "ambition, desire, diligence", "lack of commitment, greediness, laziness"],
  ["pentacles_12_knight", "pentacles", "Knight of Pentacles", "assets/images/tarot/pentacles/pentacles_12_knight.jpg", "efficiency, hard work, responsibility", "laziness, obsessiveness, work without reward"],
  ["pentacles_13_queen", "pentacles", "Queen of Pentacles", "assets/images/tarot/pentacles/pentacles_13_queen.jpg", "practicality, creature comforts, financial security", "self-centeredness, jealousy, smothering"],
  ["pentacles_14_king", "pentacles", "King of Pentacles", "assets/images/tarot/pentacles/pentacles_14_king.jpg", "abundance, prosperity, security", "greed, indulgence, sensuality"]
];

// Firestore database
const db = getFirestore(app);
const batch = writeBatch(db);

cards.map((card) => {
  // Mapping tarot card
  return {
    "id": card[0],
    "type": card[1],
    "name": card[2],
    "image_src": card[3],
    "upright": card[4],
    "reversed": card[5]
  }
}).forEach((card) => {
  // Make sure the 'tarot' doc exists
  const docRef = doc(db, "tarot", card.id);
  batch.set(docRef, card);
});

await batch.commit();

// Check if everything went right
const deckCollection = collection(db, 'tarot');
const deckSnapshot = await getDocs(deckCollection);
const deckList = deckSnapshot.docs.map(doc => doc.data());
console.log(deckList);