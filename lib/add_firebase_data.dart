import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataUploader {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadCategoryData(String category, Map<String, List<String>> data) async {
    try {
      await _firestore.collection('categories').doc(category).set(data);
    } catch (e) {
      throw Exception('Veri yükleme hatası: $e');
    }
  }

  Future<void> uploadCharacters() async {
    final Map<String, List<String>> charactersData = {
      'tr': [
        "Cesur prenses",
        "Robot arkadaş",
        "Küçük ejderha",
        "Konuşan kedi",
        "Sihirbaz çocuk",
        "Kahraman köpek",
        "Uzaylı öğrenci",
        "Hayalperest ressam",
        "Gezgin penguen",
        "Müzisyen sincap",
        "Mucit tavşan",
        "Dalgıç yunus",
        "Zaman yolcusu",
        "Süper kahraman fare",
        "Uzay pilotu",
        "Balerin kelebek",
        "Dedektif baykuş",
        "Ninja panda",
      ],
      'en': [
        "Brave princess",
        "Robot friend",
        "Little dragon",
        "Talking cat",
        "Wizard child",
        "Hero dog",
        "Alien student",
        "Dreamy painter",
        "Traveler penguin",
        "Musician squirrel",
        "Inventor rabbit",
        "Diver dolphin",
        "Time traveler",
        "Superhero mouse",
        "Space pilot",
        "Ballerina butterfly",
        "Detective owl",
        "Ninja panda",
      ],
      'es': [
        "Princesa valiente",
        "Amigo robot",
        "Pequeño dragón",
        "Gato parlante",
        "Niño mago",
        "Perro héroe",
        "Estudiante alienígena",
        "Pintor soñador",
        "Pingüino viajero",
        "Ardilla músico",
        "Conejo inventor",
        "Delfín buceador",
        "Viajero del tiempo",
        "Ratón superhéroe",
        "Piloto espacial",
        "Mariposa bailarina",
        "Búho detective",
        "Panda ninja",
      ],
    };
    await uploadCategoryData('characters', charactersData);
  }

  Future<void> uploadEmotions() async {
    final Map<String, List<String>> emotionsData = {
      'tr': [
        "Heyecan",
        "Merak",
        "Mutluluk",
        "Dostluk",
        "Cesaret",
        "Şaşkınlık",
        "Umut",
        "Sevgi",
        "Macera ruhu",
        "Yardımseverlik",
        "Özgüven",
        "Neşe",
        "Coşku",
        "Merhamet",
        "Azim",
        "Empati",
        "Yaratıcılık",
        "Minnettarlık",
      ],
      'en': [
        "Excitement",
        "Curiosity",
        "Happiness",
        "Friendship",
        "Courage",
        "Surprise",
        "Hope",
        "Love",
        "Adventurous spirit",
        "Helpfulness",
        "Confidence",
        "Joy",
        "Enthusiasm",
        "Compassion",
        "Determination",
        "Empathy",
        "Creativity",
        "Gratitude",
      ],
      'es': [
        "Emoción",
        "Curiosidad",
        "Felicidad",
        "Amistad",
        "Valentía",
        "Sorpresa",
        "Esperanza",
        "Amor",
        "Espíritu aventurero",
        "Solidaridad",
        "Confianza",
        "Alegría",
        "Entusiasmo",
        "Compasión",
        "Determinación",
        "Empatía",
        "Creatividad",
        "Gratitud",
      ],
    };
    await uploadCategoryData('emotions', emotionsData);
  }

  Future<void> uploadEvents() async {
    final Map<String, List<String>> eventsData = {
      'tr': [
        "Hazine avı",
        "Kayıp evcil hayvan arama",
        "Doğum günü sürprizi",
        "Büyülü bir kapıyı keşfetme",
        "Yeni arkadaş edinme",
        "Bilim yarışması",
        "Gizemli harita bulma",
        "Sihirli tohum yetiştirme",
        "Yıldız toplama görevi",
        "Gökkuşağı köprüsünü geçme",
        "Kayıp müzik aletini bulma",
        "Zaman yolculuğu macerası",
        "Uzay olimpiyatları",
        "Sihirli kitabın sırrı",
        "Kayıp uygarlığı keşfetme",
        "Galaktik festival",
        "Gizli güçleri keşfetme",
        "Büyülü turnuva",
      ],
      'en': [
        "Treasure hunt",
        "Lost pet search",
        "Birthday surprise",
        "Discovering a magical door",
        "Making a new friend",
        "Science competition",
        "Finding a mysterious map",
        "Growing a magical seed",
        "Star collecting mission",
        "Crossing the rainbow bridge",
        "Finding the lost instrument",
        "Time travel adventure",
        "Space olympics",
        "Secret of the magical book",
        "Discovering lost civilization",
        "Galactic festival",
        "Discovering secret powers",
        "Magical tournament",
      ],
      'es': [
        "Búsqueda del tesoro",
        "Búsqueda de mascota perdida",
        "Sorpresa de cumpleaños",
        "Descubrir una puerta mágica",
        "Hacer un nuevo amigo",
        "Competencia científica",
        "Encontrar un mapa misterioso",
        "Cultivar una semilla mágica",
        "Misión de recolección de estrellas",
        "Cruzar el puente del arcoíris",
        "Encontrar el instrumento perdido",
        "Aventura de viaje en el tiempo",
        "Olimpiadas espaciales",
        "Secreto del libro mágico",
        "Descubrir una civilización perdida",
        "Festival galáctico",
        "Descubrir poderes secretos",
        "Torneo mágico",
      ],
    };
    await uploadCategoryData('events', eventsData);
  }

  Future<void> uploadPlaces() async {
    final Map<String, List<String>> placesData = {
      'tr': [
        "Sihirli bir orman",
        "Uzay gemisi",
        "Denizaltı",
        "Peri krallığı",
        "Şeker diyarı",
        "Dinozor adası",
        "Gökkuşağı vadisi",
        "Kristal mağara",
        "Uçan ada",
        "Bulut şehri",
        "Zaman makinesi",
        "Gizli ağaç evi",
        "Kayıp şehir Atlantis",
        "Ay üssü",
        "Korsanlar adası",
        "Robotlar ülkesi",
        "Rüya bahçesi",
        "Yıldızlar arası istasyon",
      ],
      'en': [
        "Magical forest",
        "Spaceship",
        "Submarine",
        "Fairy kingdom",
        "Candy land",
        "Dinosaur island",
        "Rainbow valley",
        "Crystal cave",
        "Flying island",
        "Cloud city",
        "Time machine",
        "Secret treehouse",
        "Lost city of Atlantis",
        "Moon base",
        "Pirates island",
        "Robot country",
        "Dream garden",
        "Interstellar station",
      ],
      'es': [
        "Bosque mágico",
        "Nave espacial",
        "Submarino",
        "Reino de las hadas",
        "País de los dulces",
        "Isla de dinosaurios",
        "Valle del arcoíris",
        "Cueva de cristal",
        "Isla flotante",
        "Ciudad de las nubes",
        "Máquina del tiempo",
        "Casa del árbol secreta",
        "Ciudad perdida de Atlántida",
        "Base lunar",
        "Isla de piratas",
        "País de los robots",
        "Jardín de los sueños",
        "Estación interestelar",
      ],
    };
    await uploadCategoryData('places', placesData);
  }

  Future<void> uploadTimes() async {
    final Map<String, List<String>> timesData = {
      'tr': [
        "Çok eski zamanlarda",
        "Gelecekte",
        "Yaz tatilinde",
        "Bir kış günü",
        "Gece yarısı",
        "Sabah güneş doğarken",
        "Yıldızlar parlarken",
        "Gökkuşağı çıktığında",
        "Dolunay gecesinde",
        "İlkbahar şenliğinde",
        "Sonbahar festivalinde",
        "Zaman durduğunda",
        "Yılbaşı gecesi",
        "Meteor yağmurunda",
        "Güneş tutulmasında",
        "Karnaval zamanı",
        "Hasat mevsiminde",
        "Ay tutulmasında",
      ],
      'en': [
        "In ancient times",
        "In the future",
        "During summer vacation",
        "On a winter day",
        "At midnight",
        "At sunrise",
        "While the stars shine",
        "When a rainbow appears",
        "On a full moon night",
        "At a spring festival",
        "At an autumn festival",
        "When time stops",
        "On New Year's Eve",
        "During a meteor shower",
        "During a solar eclipse",
        "At carnival time",
        "During harvest season",
        "During a lunar eclipse",
      ],
      'es': [
        "En tiempos antiguos",
        "En el futuro",
        "Durante las vacaciones de verano",
        "En un día de invierno",
        "A medianoche",
        "Al amanecer",
        "Mientras brillan las estrellas",
        "Cuando aparece un arcoíris",
        "En una noche de luna llena",
        "En un festival de primavera",
        "En un festival de otoño",
        "Cuando el tiempo se detiene",
        "En la víspera de Año Nuevo",
        "Durante una lluvia de meteoros",
        "Durante un eclipse solar",
        "En tiempo de carnaval",
        "Durante la temporada de cosecha",
        "Durante un eclipse lunar",
      ],
    };
    await uploadCategoryData('times', timesData);
  }

  Future<void> uploadAllData() async {
    try {
      await uploadCharacters();
      await uploadEmotions();
      await uploadEvents();
      await uploadPlaces();
      await uploadTimes();
    } catch (e) {
      log('Toplu yükleme hatası: $e');
    }
  }
}