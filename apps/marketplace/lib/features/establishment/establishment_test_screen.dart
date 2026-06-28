import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';

/// Test screen for previewing the rebuilt EstablishmentPage.
///
/// Uses mock data representing House of the North (venue in Drammen).
/// This screen is temporary — will be replaced by a real data-driven
/// route once the marketplace discovery layer is built.
class EstablishmentTestScreen extends StatelessWidget {
  const EstablishmentTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EstablishmentPage(
      data: _mockEstablishment,
    );
  }
}

/// Mock establishment data for visual development and testing.
const _mockEstablishment = EstablishmentData(
  name: 'House of the North',
  businessType: EstablishmentType.venue,
  address: 'Skolegata 9',
  city: 'Drammen',
  zip: '3044',
  category: 'Spillested',
  about:
      'House of the North er Drammens nyeste og mest spennende konsert- og '
      'eventarena. Med plass til over 2000 gjester og state-of-the-art lyd '
      'og lys, tilbyr vi unike opplevelser for alle musikksjangre. '
      'Fra intime klubbkvelder til store festivaler — alt skjer under '
      'samme tak.',
  phone: '+47 32 00 00 00',
  email: 'post@houseofthenorth.no',
  website: 'https://houseofthenorth.no',
  isPublished: true,
  // TODO: Replace with real Firebase Storage URLs once media is wired.
  coverUrl:
      'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3'
      '?w=800&h=600&fit=crop',
  galleryUrls: [
    'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1429962714451-bb934ecdc4ec?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1501386761578-eac5c94b800a?w=400&h=300&fit=crop',
  ],
  openingStatus: 'Stengt i dag',
  isOpen: false,
  showServices: true,
  showEvents: true,
);
