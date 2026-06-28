import 'dart:typed_data';

import 'package:ditto_design/ditto_design.dart';
import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:media_manager/media_manager.dart';

import 'establishment_model.dart';
import 'establishment_providers.dart';
import '../media/media_providers.dart';

/// Scrollspy edit view for a single Establishment.
///
/// Refactored from tabbed view to scrollspy layout (Phase 5c).
class EstablishmentEditView extends ConsumerStatefulWidget {
  const EstablishmentEditView({
    super.key,
    required this.establishmentId,
  });

  final String establishmentId;

  @override
  ConsumerState<EstablishmentEditView> createState() =>
      _EstablishmentEditViewState();
}

class _EstablishmentEditViewState extends ConsumerState<EstablishmentEditView> {
  Establishment? _establishment;
  bool _saving = false;

  final _scrollController = ScrollController();

  final _genereltKey = GlobalKey();
  final _bilderKey = GlobalKey();
  final _lokasjonKey = GlobalKey();
  final _kontaktKey = GlobalKey();
  final _innstillingerKey = GlobalKey();

  // ── Generelt section controllers ──
  final _nameController = TextEditingController();
  final _aboutController = TextEditingController();
  BusinessType _businessType = BusinessType.store;
  String? _category;

  // ── Lokasjon section controllers ──
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();

  // ── Kontakt section controllers ──
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();

  // ── Innstillinger section state ──
  bool _isPublished = false;
  bool _resourcesEnabled = false;

  // ── Bilder section state ──
  String _coverLayoutMode = 'bento';
  List<MediaItem> _selectedLogo = [];
  List<MediaItem> _selectedCover = [];
  List<MediaItem> _selectedGallery = [];

  // ── Lokasjon geo state ──
  double? _latitude;
  double? _longitude;

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _aboutController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _loadEstablishment(Establishment est) {
    _establishment = est;
    _nameController.text = est.name;
    _aboutController.text = est.about ?? '';
    _businessType = est.businessType;
    _category = est.category;
    _addressController.text = est.address;
    _cityController.text = est.city;
    _zipController.text = est.zip;
    _phoneController.text = est.phone ?? '';
    _emailController.text = est.email ?? '';
    _websiteController.text = est.website ?? '';
    _isPublished = est.isPublished;
    _resourcesEnabled = est.resourcesEnabled;
    _coverLayoutMode = est.coverLayoutMode;
    _latitude = est.latitude;
    _longitude = est.longitude;
    // Media selections will be resolved after mediaProvider loads
    // by matching URLs to MediaItem objects.
    _selectedLogo = [];
    _selectedCover = [];
    _selectedGallery = [];
  }

  /// Match saved establishment media URLs to [MediaItem] objects.
  void _resolveMediaSelections(List<MediaItem> allMedia, Establishment est) {
    if (est.logoUrl != null) {
      final match = allMedia.where((m) => m.url == est.logoUrl);
      if (match.isNotEmpty) _selectedLogo = [match.first];
    }
    if (est.coverUrl != null) {
      final match = allMedia.where((m) => m.url == est.coverUrl);
      if (match.isNotEmpty) _selectedCover = [match.first];
    }
    if (est.galleryUrls.isNotEmpty) {
      _selectedGallery = allMedia
          .where((m) => est.galleryUrls.contains(m.url))
          .toList();
    }
  }

  /// Build an [EstablishmentData] from current form state for WYSIWYG preview.
  EstablishmentData _buildPreviewData() {
    return EstablishmentData(
      name: _nameController.text.trim().isEmpty
          ? 'Uten navn'
          : _nameController.text.trim(),
      businessType: EstablishmentType.fromString(_businessType.name),
      address: _addressController.text.trim().isEmpty
          ? 'Ingen adresse'
          : _addressController.text.trim(),
      city: _cityController.text.trim().isEmpty
          ? ''
          : _cityController.text.trim(),
      zip: _zipController.text.trim().isEmpty
          ? ''
          : _zipController.text.trim(),
      category: _category,
      about: _aboutController.text.trim().isEmpty
          ? null
          : _aboutController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      website: _websiteController.text.trim().isEmpty
          ? null
          : _websiteController.text.trim(),
      isPublished: _isPublished,
      logoUrl: _selectedLogo.isNotEmpty ? _selectedLogo.first.url : null,
      coverUrl: _selectedCover.isNotEmpty ? _selectedCover.first.url : null,
      galleryUrls: _selectedGallery.map((m) => m.url).toList(),
      coverLayoutMode: CoverLayoutMode.fromString(_coverLayoutMode),
      latitude: _latitude,
      longitude: _longitude,
    );
  }

  Future<void> _save() async {
    if (_establishment == null) return;
    setState(() => _saving = true);

    final updated = _establishment!.copyWith(
      name: _nameController.text.trim(),
      about: _aboutController.text.trim().isEmpty
          ? null
          : _aboutController.text.trim(),
      businessType: _businessType,
      category: _category,
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      zip: _zipController.text.trim(),
      phone:
          _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      email:
          _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      website: _websiteController.text.trim().isEmpty
          ? null
          : _websiteController.text.trim(),
      isPublished: _isPublished,
      resourcesEnabled: _resourcesEnabled,
      logoUrl: () => _selectedLogo.firstOrNull?.url,
      coverUrl: () => _selectedCover.firstOrNull?.url,
      galleryUrls: _selectedGallery.map((m) => m.url).toList(),
      coverLayoutMode: _coverLayoutMode,
      latitude: () => _latitude,
      longitude: () => _longitude,
    );

    await ref.read(establishmentsProvider.notifier).updateEstablishment(updated);
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lagret')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncEstablishments = ref.watch(establishmentsProvider);
    final asyncMedia = ref.watch(mediaProvider);
    final mediaItems = asyncMedia.value ?? [];
    return asyncEstablishments.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Feil: $e')),
      data: (establishments) {
        final est = establishments.where((e) => e.id == widget.establishmentId);
        if (est.isEmpty) {
          return const Center(child: Text('Virksomheten ble ikke funnet'));
        }

        // Initialize controllers on first load or when ID changes.
        if (_establishment?.id != est.first.id) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _loadEstablishment(est.first);
                // Resolve saved media URLs to MediaItem objects
                _resolveMediaSelections(mediaItems, est.first);
              });
            }
          });
          return const Center(child: CircularProgressIndicator());
        }

        // Re-resolve media selections when media items load/change
        // (e.g. after initial load or after an upload).
        if (_selectedLogo.isEmpty &&
            _selectedCover.isEmpty &&
            _selectedGallery.isEmpty &&
            mediaItems.isNotEmpty &&
            _establishment != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _resolveMediaSelections(mediaItems, _establishment!));
            }
          });
        }

        final sections = [
          DittoScrollspySection(
            key: _genereltKey,
            label: 'Generelt',
            icon: Icons.info_outline_rounded,
            content: _GenereltSection(
              nameController: _nameController,
              aboutController: _aboutController,
              businessType: _businessType,
              category: _category,
              onCategoryChanged: (c) => setState(() => _category = c),
            ),
          ),
          DittoScrollspySection(
            key: _bilderKey,
            label: 'Bilder',
            icon: Icons.image_outlined,
            content: _BilderSection(
              ref: ref,
              coverLayoutMode: _coverLayoutMode,
              onCoverLayoutModeChanged: (mode) =>
                  setState(() => _coverLayoutMode = mode),
              selectedLogo: _selectedLogo,
              onLogoChanged: (items) =>
                  setState(() => _selectedLogo = items),
              selectedCover: _selectedCover,
              onCoverChanged: (items) =>
                  setState(() => _selectedCover = items),
              selectedGallery: _selectedGallery,
              onGalleryChanged: (items) =>
                  setState(() => _selectedGallery = items),
            ),
          ),
          DittoScrollspySection(
            key: _lokasjonKey,
            label: 'Lokasjon',
            icon: Icons.location_on_outlined,
            content: _LokasjonSection(
              addressController: _addressController,
              cityController: _cityController,
              zipController: _zipController,
              latitude: _latitude,
              longitude: _longitude,
              onLocationChanged: (lat, lng) {
                setState(() {
                  _latitude = lat;
                  _longitude = lng;
                });
              },
            ),
          ),
          DittoScrollspySection(
            key: _kontaktKey,
            label: 'Kontakt',
            icon: Icons.contact_phone_outlined,
            content: _KontaktSection(
              phoneController: _phoneController,
              emailController: _emailController,
              websiteController: _websiteController,
            ),
          ),
          DittoScrollspySection(
            key: _innstillingerKey,
            label: 'Innstillinger',
            icon: Icons.settings_outlined,
            content: _InnstillingerSection(
              isPublished: _isPublished,
              resourcesEnabled: _resourcesEnabled,
              onPublishedChanged: (v) => setState(() => _isPublished = v),
              onResourcesChanged: (v) => setState(() => _resourcesEnabled = v),
            ),
          ),
        ];

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              tooltip: 'Virksomheter',
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Row(
              children: [
                Text(_establishment?.name ?? ''),
                const SizedBox(width: DittoSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _isPublished
                        ? Colors.green.withValues(alpha: 0.12)
                        : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isPublished
                          ? Colors.green.withValues(alpha: 0.5)
                          : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    _isPublished ? 'Publisert' : 'Utkast',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _isPublished ? Colors.green : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              // Preview toggle button — navigates to full-screen preview
              IconButton(
                icon: const Icon(Icons.visibility_rounded),
                tooltip: 'Forhåndsvisning',
                onPressed: () {
                  context.push(
                    '/establishments/preview',
                    extra: _buildPreviewData(),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: DittoSpacing.base),
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Lagre'),
                ),
              ),
            ],
          ),
          body: DittoScrollspyLayout(
                  sections: sections,
                  scrollController: _scrollController,
                ),
        );
      },
    );
  }
}

// ── Section 1: Generelt ──

class _GenereltSection extends StatelessWidget {
  const _GenereltSection({
    required this.nameController,
    required this.aboutController,
    required this.businessType,
    this.category,
    required this.onCategoryChanged,
  });

  final TextEditingController nameController;
  final TextEditingController aboutController;
  final BusinessType businessType;
  final String? category;
  final ValueChanged<String?> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Navn'),
        ),
        const SizedBox(height: DittoSpacing.base),

        TextFormField(
          initialValue: category,
          decoration: const InputDecoration(
            labelText: 'Kategori',
            hintText: 'f.eks. Frisør, Pizza, Konsert',
          ),
          onChanged: onCategoryChanged,
        ),
        const SizedBox(height: DittoSpacing.base),

        TextFormField(
          controller: aboutController,
          decoration: const InputDecoration(
            labelText: 'Om virksomheten',
            hintText: 'Kort beskrivelse...',
            alignLabelWithHint: true,
          ),
          maxLines: 4,
        ),
      ],
    );
  }
}

class _LokasjonSection extends StatefulWidget {
  const _LokasjonSection({
    required this.addressController,
    required this.cityController,
    required this.zipController,
    this.latitude,
    this.longitude,
    this.onLocationChanged,
  });

  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController zipController;
  final double? latitude;
  final double? longitude;
  final void Function(double lat, double lng)? onLocationChanged;

  @override
  State<_LokasjonSection> createState() => _LokasjonSectionState();
}

class _LokasjonSectionState extends State<_LokasjonSection> {
  final _kartverket = KartverketService();
  final _nominatim = NominatimService();
  List<NorwegianAddress> _suggestions = [];
  bool _searching = false;
  bool _geocoding = false;
  double? _lat;
  double? _lng;

  // Debounce timer for address search.
  DateTime _lastSearch = DateTime.now();

  @override
  void initState() {
    super.initState();
    _lat = widget.latitude;
    _lng = widget.longitude;
  }

  @override
  void didUpdateWidget(covariant _LokasjonSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync lat/lng if parent pushes new values (e.g. on load).
    if (widget.latitude != oldWidget.latitude ||
        widget.longitude != oldWidget.longitude) {
      _lat = widget.latitude;
      _lng = widget.longitude;
    }
  }

  @override
  void dispose() {
    _kartverket.dispose();
    _nominatim.dispose();
    super.dispose();
  }

  Future<void> _onAddressChanged(String query) async {
    if (query.trim().length < KartverketService.minQueryLength) {
      if (_suggestions.isNotEmpty) {
        setState(() => _suggestions = []);
      }
      return;
    }

    // Simple debounce — skip if another search happened within 300ms.
    final now = DateTime.now();
    _lastSearch = now;
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (_lastSearch != now || !mounted) return;

    setState(() => _searching = true);
    final results = await _kartverket.search(query);
    if (!mounted) return;
    setState(() {
      _suggestions = results;
      _searching = false;
    });
  }

  void _onSuggestionSelected(NorwegianAddress address) {
    widget.addressController.text = address.streetAddress;
    widget.cityController.text = address.city;
    widget.zipController.text = address.postalCode;
    setState(() => _suggestions = []);

    // Kartverket often provides coordinates directly.
    if (address.latitude != null && address.longitude != null) {
      _updateLocation(address.latitude!, address.longitude!);
    } else {
      // Fallback: geocode via Nominatim.
      _geocodeCurrentAddress();
    }
  }

  Future<void> _geocodeCurrentAddress() async {
    final address = widget.addressController.text.trim();
    final city = widget.cityController.text.trim();
    final zip = widget.zipController.text.trim();
    if (address.isEmpty) return;

    final fullAddress = '$address, $zip $city';
    setState(() => _geocoding = true);
    final result = await _nominatim.geocode(fullAddress);
    if (!mounted) return;
    setState(() => _geocoding = false);

    if (result != null) {
      _updateLocation(result.latitude, result.longitude);
    }
  }

  void _updateLocation(double lat, double lng) {
    setState(() {
      _lat = lat;
      _lng = lng;
    });
    widget.onLocationChanged?.call(lat, lng);
  }

  bool get _hasLocation => _lat != null && _lng != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Address field with Kartverket autocomplete ──
        TextFormField(
          controller: widget.addressController,
          decoration: InputDecoration(
            labelText: 'Gateadresse',
            hintText: 'Søk adresse...',
            suffixIcon: _searching
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : const Icon(Icons.search),
          ),
          onChanged: _onAddressChanged,
        ),

        // ── Autocomplete suggestions dropdown ──
        if (_suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: DittoBorderRadius.mediumAll,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _suggestions.map((addr) {
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.location_on_outlined, size: 20),
                  title: Text(addr.streetAddress),
                  subtitle: Text(
                    '${addr.postalCode} ${addr.city}',
                    style: theme.textTheme.bodySmall,
                  ),
                  onTap: () => _onSuggestionSelected(addr),
                );
              }).toList(),
            ),
          ),

        const SizedBox(height: DittoSpacing.base),

        // ── City / Zip row ──
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: widget.cityController,
                decoration: const InputDecoration(labelText: 'By'),
              ),
            ),
            const SizedBox(width: DittoSpacing.base),
            Expanded(
              child: TextFormField(
                controller: widget.zipController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Postnummer'),
              ),
            ),
          ],
        ),

        const SizedBox(height: DittoSpacing.base),

        // ── Geocode button ──
        if (!_hasLocation)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _geocoding ? null : _geocodeCurrentAddress,
              icon: _geocoding
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location, size: 18),
              label: const Text('Finn på kart'),
            ),
          ),

        const SizedBox(height: DittoSpacing.sm),

        // ── Map ──
        if (_hasLocation)
          ClipRRect(
            borderRadius: DittoBorderRadius.mediumAll,
            child: SizedBox(
              height: 220,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(_lat!, _lng!),
                  initialZoom: 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'no.dittodatto.portal',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(_lat!, _lng!),
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.location_on,
                          color: theme.colorScheme.primary,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        else
          // Placeholder when no coordinates
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              borderRadius: DittoBorderRadius.mediumAll,
              border: Border.all(
                color: theme.colorScheme.outlineVariant
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 40,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: DittoSpacing.sm),
                  Text(
                    'Skriv en adresse for å vise kartet',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ── Section 3: Kontakt ──

class _KontaktSection extends StatelessWidget {
  const _KontaktSection({
    required this.phoneController,
    required this.emailController,
    required this.websiteController,
  });

  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController websiteController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Telefon',
            hintText: '+47 XXX XX XXX',
            prefixIcon: Icon(Icons.phone_outlined),
          ),
        ),
        const SizedBox(height: DittoSpacing.base),
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'E-post',
            hintText: 'post@virksomhet.no',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: DittoSpacing.base),
        TextFormField(
          controller: websiteController,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(
            labelText: 'Nettside',
            hintText: 'https://virksomhet.no',
            prefixIcon: Icon(Icons.language_outlined),
          ),
        ),
      ],
    );
  }
}

// ── Section 4: Innstillinger ──

class _InnstillingerSection extends StatelessWidget {
  const _InnstillingerSection({
    required this.isPublished,
    required this.resourcesEnabled,
    required this.onPublishedChanged,
    required this.onResourcesChanged,
  });

  final bool isPublished;
  final bool resourcesEnabled;
  final ValueChanged<bool> onPublishedChanged;
  final ValueChanged<bool> onResourcesChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Publish toggle
        SwitchListTile(
          title: const Text('Publiser virksomhet'),
          subtitle: const Text(
            'Gjør denne virksomheten synlig for kunder',
          ),
          value: isPublished,
          onChanged: onPublishedChanged,
        ),

        const Divider(height: DittoSpacing.xl),

        // Resource management toggle
        SwitchListTile(
          title: const Text('Ressurshåndtering'),
          subtitle: const Text(
            'Aktiver behandling av ressurser og kapasitet',
          ),
          value: resourcesEnabled,
          onChanged: onResourcesChanged,
        ),
      ],
    );
  }
}

// ── Section 5: Bilder ──

class _BilderSection extends StatelessWidget {
  const _BilderSection({
    required this.ref,
    required this.coverLayoutMode,
    required this.onCoverLayoutModeChanged,
    required this.selectedLogo,
    required this.onLogoChanged,
    required this.selectedCover,
    required this.onCoverChanged,
    required this.selectedGallery,
    required this.onGalleryChanged,
  });

  final WidgetRef ref;
  final String coverLayoutMode;
  final ValueChanged<String> onCoverLayoutModeChanged;
  final List<MediaItem> selectedLogo;
  final ValueChanged<List<MediaItem>> onLogoChanged;
  final List<MediaItem> selectedCover;
  final ValueChanged<List<MediaItem>> onCoverChanged;
  final List<MediaItem> selectedGallery;
  final ValueChanged<List<MediaItem>> onGalleryChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final asyncMedia = ref.watch(mediaProvider);
    final uploadState = ref.watch(mediaUploadStateProvider);
    final mediaItems = asyncMedia.value ?? [];
    final isLoading = asyncMedia.isLoading;

    Future<void> handleUpload({
      required MediaCategory category,
      required List<({Uint8List bytes, String filename, String mimeType, int size})> files,
    }) async {
      await ref.read(mediaProvider.notifier).uploadMultiple(
            files: files,
            category: category,
          );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Cover Layout Mode ──
        Text(
          'Omslagsvisning',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: DittoSpacing.xs),
        Text(
          'Velg hvordan omslagsbilder vises på forhåndsvisningssiden',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: DittoSpacing.base),

        Row(
          children: [
            _CoverLayoutCard(
              label: 'Bento Grid',
              description: '2/4 omslag + 2×2\ngallerigrid',
              icon: Icons.grid_view_rounded,
              value: 'bento',
              selected: coverLayoutMode == 'bento',
              onTap: () => onCoverLayoutModeChanged('bento'),
            ),
            const SizedBox(width: DittoSpacing.sm),
            _CoverLayoutCard(
              label: 'Showcase',
              description: '3/4 omslag +\nvertikal rullegaleri',
              icon: Icons.view_carousel_rounded,
              value: 'showcase',
              selected: coverLayoutMode == 'showcase',
              onTap: () => onCoverLayoutModeChanged('showcase'),
            ),
            const SizedBox(width: DittoSpacing.sm),
            _CoverLayoutCard(
              label: 'Spotlight',
              description: 'Fullbredde\nomslagsbilde',
              icon: Icons.panorama_wide_angle_rounded,
              value: 'spotlight',
              selected: coverLayoutMode == 'spotlight',
              onTap: () => onCoverLayoutModeChanged('spotlight'),
            ),
          ],
        ),

        const SizedBox(height: DittoSpacing.xl),
        const Divider(),
        const SizedBox(height: DittoSpacing.lg),

        // ── Cover Image ──
        MediaPickerWidget(
          items: mediaItems,
          isLoading: isLoading,
          uploadState: uploadState,
          onUpload: handleUpload,
          maxSelection: 1,
          defaultCategory: MediaCategory.cover,
          selectedItems: selectedCover,
          onChanged: onCoverChanged,
          label: 'Omslagsbilde',
          hint: 'Hovedbilde for virksomheten',
        ),

        const SizedBox(height: DittoSpacing.xl),

        // ── Gallery Images ──
        MediaPickerWidget(
          items: mediaItems,
          isLoading: isLoading,
          uploadState: uploadState,
          onUpload: handleUpload,
          defaultCategory: MediaCategory.gallery,
          selectedItems: selectedGallery,
          onChanged: onGalleryChanged,
          label: 'Galleribilder',
          hint: 'Tilleggsbilder vist ved omslagsbildet',
        ),

        const SizedBox(height: DittoSpacing.xl),

        // ── Logo ──
        MediaPickerWidget(
          items: mediaItems,
          isLoading: isLoading,
          uploadState: uploadState,
          onUpload: handleUpload,
          maxSelection: 1,
          defaultCategory: MediaCategory.logo,
          selectedItems: selectedLogo,
          onChanged: onLogoChanged,
          label: 'Logo',
          hint: 'Lite logo vist på infolinjen',
        ),
      ],
    );
  }
}

// ── Cover Layout Mode Card ──

class _CoverLayoutCard extends StatelessWidget {
  const _CoverLayoutCard({
    required this.label,
    required this.description,
    required this.icon,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String description;
  final IconData icon;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final moodyBlue = theme.colorScheme.primary;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(DittoSpacing.base),
          decoration: BoxDecoration(
            color: selected
                ? moodyBlue.withValues(alpha: 0.08)
                : theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
            borderRadius: DittoBorderRadius.mediumAll,
            border: Border.all(
              color: selected
                  ? moodyBlue
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 28,
                color: selected
                    ? moodyBlue
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: DittoSpacing.xs),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? moodyBlue
                      : theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.3,
                ),
              ),
              if (selected) ...[
                const SizedBox(height: DittoSpacing.xs),
                Icon(Icons.check_circle_rounded, size: 18, color: moodyBlue),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
