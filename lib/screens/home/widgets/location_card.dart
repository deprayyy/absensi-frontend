import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../../services/location_service.dart';

class LocationCard extends StatefulWidget {
  const LocationCard({super.key});

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  final MapController _mapController = MapController();

  /// Auto follow ke user location
  void _followUser(LocationService service) {
    final lat = service.latitude;
    final lng = service.longitude;

    if (lat != null && lng != null && !service.isLoading) {
      _mapController.move(LatLng(lat, lng), 17);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationService = context.watch<LocationService>();

    // 🔥 update map kalau ada lokasi baru
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _followUser(locationService);
    });

    return FadeInUp(
      duration: const Duration(milliseconds: 1200),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Builder(
              builder: (context) {
                if (locationService.isLoading) {
                  // 🔄 Kalau lagi ambil lokasi pertama kali
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text(
                          "Mengambil lokasi...",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }

                if (!locationService.serviceEnabled) {
                  // 🚫 Kalau service lokasi dimatiin user
                  return const Center(
                    child: Text(
                      "Layanan lokasi dimatikan.\nAktifkan GPS untuk melanjutkan.",
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (locationService.permission == null ||
                    locationService.permission.toString().contains("denied")) {
                  // 🚫 Kalau user belum ngasih izin lokasi
                  return const Center(
                    child: Text(
                      "Menunggu izin lokasi...",
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (!locationService.hasLocation) {
                  // ℹ️ Kalau belum ada koordinat valid
                  return const Center(
                    child: Text("Lokasi belum tersedia"),
                  );
                }

                // ✅ Lokasi tersedia → tampilkan map
                return Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        // fallback Jakarta kalau null
                        initialCenter: LatLng(
                          locationService.latitude ?? -6.200000,
                          locationService.longitude ?? 106.816666,
                        ),
                        initialZoom: 15,
                        interactionOptions: const InteractionOptions(),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: const ['a', 'b', 'c'],
                          userAgentPackageName: 'com.example.mapss',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(
                                locationService.latitude ?? -6.200000,
                                locationService.longitude ?? 106.816666,
                              ),
                              width: 50,
                              height: 50,
                              child: ZoomIn(
                                duration: const Duration(milliseconds: 1500),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    /// 📍 Overlay koordinat
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: FadeIn(
                        duration: const Duration(milliseconds: 1400),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Lat: ${locationService.latitude!.toStringAsFixed(6)} | "
                                "Lng: ${locationService.longitude!.toStringAsFixed(6)}",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
