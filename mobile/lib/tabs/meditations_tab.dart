import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/meditation_track.dart';
import '../providers/meditation_provider.dart';
import '../screens/meditation_player_screen.dart';
import '../widgets/meditation_track_menu.dart';
import '../widgets/mini_player_bar.dart';

class MeditationsTab extends StatefulWidget {
  const MeditationsTab({super.key});

  @override
  State<MeditationsTab> createState() => _MeditationsTabState();
}

class _MeditationsTabState extends State<MeditationsTab>
    with TickerProviderStateMixin {
  String _selectedCategory = 'audio';
  String _selectedFilter = 'all';
  MeditationTrack? _currentTrack;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // Load tracks from API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MeditationProvider>().loadTracks(category: _selectedCategory);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    context.read<MeditationProvider>().loadTracks(category: category);
  }

  void _playTrack(MeditationTrack track) {
    setState(() {
      _currentTrack = track;
      _isPlaying = true;
      _totalDuration = Duration(seconds: track.duration);
      _currentPosition = Duration.zero;
    });
    
    _animationController.forward();
    
    // Navigate to full player
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeditationPlayerScreen(
          track: track,
          onTrackChanged: (newTrack) {
            setState(() {
              _currentTrack = newTrack;
            });
          },
        ),
      ),
    );
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _showTrackMenu(MeditationTrack track) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _hexToColor('1B0A33'),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => MeditationTrackMenu(track: track),
    );
  }

  Duration _parseDuration(String duration) {
    final parts = duration.split(':');
    final minutes = int.parse(parts[0]);
    final seconds = int.parse(parts[1]);
    return Duration(minutes: minutes, seconds: seconds);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}';
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');
    final provider = context.watch<MeditationProvider>();

    return Scaffold(
      backgroundColor: _hexToColor('1B0A33'),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: lightTextColor,
                    size: 24,
                  ),
                  Text(
                    'Meditations',
                    style: GoogleFonts.dmSans(
                      color: lightTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: lightTextColor,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: purpleAccent.withOpacity(0.3),
                        ),
                        child: Icon(
                          Icons.person,
                          color: lightTextColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Category tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: ['audio', 'music', 'sleep'].map((category) {
                  final isSelected = _selectedCategory == category;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _onCategoryChanged(category),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? purpleAccent.withOpacity(0.3)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? purpleAccent
                                : lightTextColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          category.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            color: isSelected
                                ? lightTextColor
                                : lightTextColor.withOpacity(0.6),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Filter tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: ['all', 'albums', 'music', 'live'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? purpleAccent
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        filter.toUpperCase(),
                        style: GoogleFonts.dmSans(
                          color: isSelected
                              ? lightTextColor
                              : lightTextColor.withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Track count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text(
                    '${provider.tracks.length} audios',
                    style: GoogleFonts.dmSans(
                      color: lightTextColor.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Loading/Error/Tracks list
            Expanded(
              child: provider.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: purpleAccent,
                      ),
                    )
                  : provider.error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                provider.error!,
                                style: GoogleFonts.dmSans(
                                  color: lightTextColor,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => provider.loadTracks(category: _selectedCategory),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: purpleAccent,
                                ),
                                child: Text(
                                  'Retry',
                                  style: GoogleFonts.dmSans(
                                    color: lightTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: provider.tracks.length,
                          itemBuilder: (context, index) {
                            final track = provider.tracks[index];
                  final isCurrentTrack = _currentTrack?.id == track.id;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isCurrentTrack
                          ? purpleAccent.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: GestureDetector(
                        onTap: () => _playTrack(track),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: purpleAccent,
                          ),
                          child: Icon(
                            isCurrentTrack && _isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: lightTextColor,
                            size: 24,
                          ),
                        ),
                      ),
                      title: Text(
                        track.title,
                        style: GoogleFonts.dmSans(
                          color: lightTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        track.artist,
                        style: GoogleFonts.dmSans(
                          color: lightTextColor.withOpacity(0.6),
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            track.formattedDuration,
                            style: GoogleFonts.dmSans(
                              color: lightTextColor.withOpacity(0.6),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _showTrackMenu(track),
                            child: Icon(
                              Icons.more_vert,
                              color: lightTextColor.withOpacity(0.6),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => _playTrack(track),
                    ),
                  );
                          },
                        ),
            ),

            // Mini player bar
            if (_currentTrack != null)
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeInOut,
                )),
                child: MiniPlayerBar(
                  track: _currentTrack!,
                  isPlaying: _isPlaying,
                  onTogglePlayPause: _togglePlayPause,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MeditationPlayerScreen(
                          track: _currentTrack!,
                          onTrackChanged: (newTrack) {
                            setState(() {
                              _currentTrack = newTrack;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
