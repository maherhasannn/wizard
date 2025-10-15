import '../models/meditation_track.dart';

class MeditationData {
  static final List<MeditationTrack> tracks = [
    // Audio Category
    const MeditationTrack(
      id: '1',
      title: 'Whispers of the Thunder',
      artist: '@monocorde',
      duration: '2:00',
      category: 'audio',
      imageUrl: 'assets/images/meditation1.jpg',
      audioUrl: 'assets/audio/thunder_whispers.mp3',
    ),
    const MeditationTrack(
      id: '2',
      title: 'The first summer thunder',
      artist: '@thewizard',
      duration: '3:00',
      category: 'audio',
      imageUrl: 'assets/images/meditation2.jpg',
      audioUrl: 'assets/audio/summer_thunder.mp3',
    ),
    const MeditationTrack(
      id: '3',
      title: 'The Awakening Storm',
      artist: '@monocorde',
      duration: '4:30',
      category: 'audio',
      imageUrl: 'assets/images/meditation3.jpg',
      audioUrl: 'assets/audio/awakening_storm.mp3',
    ),
    const MeditationTrack(
      id: '4',
      title: 'Quantum Thunder',
      artist: '@thewizard',
      duration: '2:45',
      category: 'audio',
      imageUrl: 'assets/images/meditation4.jpg',
      audioUrl: 'assets/audio/quantum_thunder.mp3',
    ),
    const MeditationTrack(
      id: '5',
      title: 'The Fostering Storm',
      artist: '@monocorde',
      duration: '3:15',
      category: 'audio',
      imageUrl: 'assets/images/meditation5.jpg',
      audioUrl: 'assets/audio/fostering_storm.mp3',
    ),
    const MeditationTrack(
      id: '6',
      title: 'Deep Healing Meditation',
      artist: '@monocorde',
      duration: '5:00',
      category: 'audio',
      imageUrl: 'assets/images/meditation6.jpg',
      audioUrl: 'assets/audio/deep_healing.mp3',
    ),
    const MeditationTrack(
      id: '7',
      title: 'Mindful Breathing',
      artist: '@thewizard',
      duration: '2:30',
      category: 'audio',
      imageUrl: 'assets/images/meditation7.jpg',
      audioUrl: 'assets/audio/mindful_breathing.mp3',
    ),
    const MeditationTrack(
      id: '8',
      title: 'Ocean Waves',
      artist: '@monocorde',
      duration: '6:00',
      category: 'audio',
      imageUrl: 'assets/images/meditation8.jpg',
      audioUrl: 'assets/audio/ocean_waves.mp3',
    ),
    const MeditationTrack(
      id: '9',
      title: 'Forest Rain',
      artist: '@thewizard',
      duration: '4:15',
      category: 'audio',
      imageUrl: 'assets/images/meditation9.jpg',
      audioUrl: 'assets/audio/forest_rain.mp3',
    ),
    const MeditationTrack(
      id: '10',
      title: 'Mountain Silence',
      artist: '@monocorde',
      duration: '3:45',
      category: 'audio',
      imageUrl: 'assets/images/meditation10.jpg',
      audioUrl: 'assets/audio/mountain_silence.mp3',
    ),

    // Music Category
    const MeditationTrack(
      id: '11',
      title: 'Tranquility - Deep Healing Relaxing Music',
      artist: '@monocorde',
      duration: '8:00',
      category: 'music',
      imageUrl: 'assets/images/music1.jpg',
      audioUrl: 'assets/audio/tranquility.mp3',
    ),
    const MeditationTrack(
      id: '12',
      title: 'Celestial Harmonies',
      artist: '@thewizard',
      duration: '7:30',
      category: 'music',
      imageUrl: 'assets/images/music2.jpg',
      audioUrl: 'assets/audio/celestial.mp3',
    ),
    const MeditationTrack(
      id: '13',
      title: 'Ambient Dreams',
      artist: '@monocorde',
      duration: '6:45',
      category: 'music',
      imageUrl: 'assets/images/music3.jpg',
      audioUrl: 'assets/audio/ambient_dreams.mp3',
    ),
    const MeditationTrack(
      id: '14',
      title: 'Sacred Chants',
      artist: '@thewizard',
      duration: '5:20',
      category: 'music',
      imageUrl: 'assets/images/music4.jpg',
      audioUrl: 'assets/audio/sacred_chants.mp3',
    ),
    const MeditationTrack(
      id: '15',
      title: 'Zen Garden',
      artist: '@monocorde',
      duration: '4:50',
      category: 'music',
      imageUrl: 'assets/images/music5.jpg',
      audioUrl: 'assets/audio/zen_garden.mp3',
    ),

    // Sleep Category
    const MeditationTrack(
      id: '16',
      title: 'Sleep Stories - Starlight Journey',
      artist: '@thewizard',
      duration: '12:00',
      category: 'sleep',
      imageUrl: 'assets/images/sleep1.jpg',
      audioUrl: 'assets/audio/starlight_journey.mp3',
    ),
    const MeditationTrack(
      id: '17',
      title: 'Deep Sleep Hypnosis',
      artist: '@monocorde',
      duration: '15:00',
      category: 'sleep',
      imageUrl: 'assets/images/sleep2.jpg',
      audioUrl: 'assets/audio/deep_sleep.mp3',
    ),
    const MeditationTrack(
      id: '18',
      title: 'White Noise - Rain',
      artist: '@thewizard',
      duration: '10:00',
      category: 'sleep',
      imageUrl: 'assets/images/sleep3.jpg',
      audioUrl: 'assets/audio/white_noise_rain.mp3',
    ),
    const MeditationTrack(
      id: '19',
      title: 'Sleep Meditation - Body Scan',
      artist: '@monocorde',
      duration: '8:30',
      category: 'sleep',
      imageUrl: 'assets/images/sleep4.jpg',
      audioUrl: 'assets/audio/body_scan.mp3',
    ),
    const MeditationTrack(
      id: '20',
      title: 'Peaceful Dreams',
      artist: '@thewizard',
      duration: '11:15',
      category: 'sleep',
      imageUrl: 'assets/images/sleep5.jpg',
      audioUrl: 'assets/audio/peaceful_dreams.mp3',
    ),

    // Additional tracks to reach 25
    const MeditationTrack(
      id: '21',
      title: 'Morning Energy Boost',
      artist: '@monocorde',
      duration: '3:30',
      category: 'audio',
      imageUrl: 'assets/images/meditation11.jpg',
      audioUrl: 'assets/audio/morning_energy.mp3',
    ),
    const MeditationTrack(
      id: '22',
      title: 'Evening Wind Down',
      artist: '@thewizard',
      duration: '4:00',
      category: 'audio',
      imageUrl: 'assets/images/meditation12.jpg',
      audioUrl: 'assets/audio/evening_wind.mp3',
    ),
    const MeditationTrack(
      id: '23',
      title: 'Stress Relief',
      artist: '@monocorde',
      duration: '3:20',
      category: 'audio',
      imageUrl: 'assets/images/meditation13.jpg',
      audioUrl: 'assets/audio/stress_relief.mp3',
    ),
    const MeditationTrack(
      id: '24',
      title: 'Focus & Concentration',
      artist: '@thewizard',
      duration: '2:50',
      category: 'audio',
      imageUrl: 'assets/images/meditation14.jpg',
      audioUrl: 'assets/audio/focus.mp3',
    ),
    const MeditationTrack(
      id: '25',
      title: 'Self Love Affirmations',
      artist: '@monocorde',
      duration: '3:45',
      category: 'audio',
      imageUrl: 'assets/images/meditation15.jpg',
      audioUrl: 'assets/audio/self_love.mp3',
    ),
  ];

  static List<MeditationTrack> getTracksByCategory(String category) {
    return tracks.where((track) => track.category == category).toList();
  }

  static List<MeditationTrack> getAllTracks() {
    return tracks;
  }

  static MeditationTrack? getTrackById(String id) {
    try {
      return tracks.firstWhere((track) => track.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<String> getCategories() {
    return ['audio', 'music', 'sleep'];
  }

  static List<String> getFilterTypes() {
    return ['all', 'albums', 'music', 'live'];
  }
}
