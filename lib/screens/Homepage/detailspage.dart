// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givelive/models.dart';
import 'package:givelive/screens/alert/org_request.dart';
import 'package:givelive/screens/Homepage/create_donation.dart';
import 'package:givelive/screens/Homepage/donation_detail.dart';
import 'package:givelive/provider/donation_provider.dart';
import 'package:givelive/provider/community_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../resuable/colors.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DonationProvider>(context, listen: false).fetchDonations();
      Provider.of<CommunityProvider>(context, listen: false).fetchCommunities();
    });
  }

  @override
  Widget build(BuildContext context) {
    double hei = MediaQuery.of(context).size.height;
    double wid = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 0.077 * hei,
                padding: EdgeInsets.only(left: 0.03 * wid, top: 0.015 * hei),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // height: 0.1 * hei,
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            'assets/icons/locicon.svg',
                            fit: BoxFit.fitHeight,
                          ),
                          // iconSize: 33,
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.fromLTRB(0, 0.007 * hei, 0, 0),
                              child: Text(
                                'Jenna Ortega',
                                style: TextStyle(
                                    fontSize: 0.02 * hei,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              child: Text(
                                'OMR Navulur, 25th Lane, Chenn...',
                                style: TextStyle(
                                    fontSize: 0.01 * hei,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade500),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 0.035 * wid),
                      height: hei * 0.055,
                      child: IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                              'assets/icons/notificationicon.svg',
                              fit: BoxFit.fitHeight)),
                    )
                  ],
                ),
              ),
              Stack(children: [
                ClipRRect(
                  child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      margin: EdgeInsets.fromLTRB(0.05 * wid, 0, 0.05 * wid, 0),
                      height: 0.2 * hei,
                      child: Image.asset('assets/Rectangle 43.png')),
                ),
                ClipRRect(
                  child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      margin: EdgeInsets.fromLTRB(0.05 * wid, 0, 0.05 * wid, 0),
                      height: 0.2 * hei,
                      child: SvgPicture.asset('assets/htab.svg')),
                ),
              ]),
              Container(
                margin: EdgeInsets.only(left: 0.05 * wid),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Org. Requests",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 0.025 * hei),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all organization requests
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(color: red, fontFamily: 'Poppins'),
                      ),
                    ),
                  ],
                ),
              ),
              // Organization Requests Section
              Consumer<DonationProvider>(
                builder: (context, donationProvider, child) {
                  final orgDonations = donationProvider.donations
                      .where((d) => d.organizationId != null)
                      .take(5)
                      .toList();

                  if (orgDonations.isEmpty) {
                    return Container(
                      height: 0.15 * hei,
                      child: Center(
                        child: Text(
                          'No organization requests available',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  return Container(
                    height: hei * 0.21,
                    padding: EdgeInsets.symmetric(horizontal: 0.03 * wid),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: orgDonations.length,
                      itemBuilder: (context, index) {
                        final donation = orgDonations[index];
                        return _buildOrgDonationCard(donation, wid, hei);
                      },
                    ),
                  );
                },
              ),
              Container(
                margin: EdgeInsets.only(left: 0.05 * wid),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Nearby Requests",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 0.025 * hei),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all nearby requests
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(color: red, fontFamily: 'Poppins'),
                      ),
                    ),
                  ],
                ),
              ),
              // Nearby Requests Section
              Consumer<DonationProvider>(
                builder: (context, donationProvider, child) {
                  final nearbyDonations = donationProvider.nearbyDonations.take(5).toList();

                  if (nearbyDonations.isEmpty) {
                    return Container(
                      height: 0.15 * hei,
                      child: Center(
                        child: Text(
                          'No nearby requests available',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  return Container(
                    height: hei * 0.20,
                    margin: EdgeInsets.symmetric(horizontal: 0.03 * wid),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: nearbyDonations.length,
                      itemBuilder: (context, index) {
                        final donation = nearbyDonations[index];
                        return _buildNearbyRequestCard(donation, wid, hei);
                      },
                    ),
                  );
                },
              ),
              Container(
                margin: EdgeInsets.only(left: 0.05 * wid),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top Communities",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all communities
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(color: red, fontFamily: 'Poppins'),
                      ),
                    ),
                  ],
                ),
              ),
              // Top Communities Section
              Consumer<CommunityProvider>(
                builder: (context, communityProvider, child) {
                  final topCommunities = communityProvider.topCommunities;

                  if (topCommunities.isEmpty) {
                    return Container(
                      height: 0.1 * hei,
                      child: Center(
                        child: Text(
                          'No communities available',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  return Container(
                    height: 0.1 * hei,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: topCommunities.length,
                      itemBuilder: (context, index) {
                        final community = topCommunities[index];
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage: NetworkImage(community.imageUrl),
                          ),
                        );
                      },
                    ),
                  );
                },
              )
            ],
          ),
          // Quick Actions
          Container(
            margin: EdgeInsets.symmetric(horizontal: 0.05 * wid, vertical: 0.02 * hei),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateDonationPage()),
                      );
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text(
                      'Raise Request',
                      style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 0.04 * wid),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/create-community');
                    },
                    icon: Icon(Icons.group_add, color: red),
                    label: Text(
                      'Join Community',
                      style: TextStyle(color: red, fontFamily: 'Poppins'),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrgDonationCard(DonationModel donation, double wid, double hei) {
    return Container(
      width: 0.50 * wid,
      margin: EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DonationDetailPage(donation: donation),
            ),
          );
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 0.08 * hei,
                padding: EdgeInsets.fromLTRB(0.02 * wid, 0.01 * hei, 0.02 * wid, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    donation.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.image, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0.03 * wid, 0.01 * hei, 0.03 * wid, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        donation.donorName,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 0.015 * hei,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (donation.organizationId != null)
                      Icon(
                        Icons.verified_sharp,
                        color: red,
                        size: 0.015 * hei,
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0.025 * wid, 0, 0.02 * wid, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.add_location,
                          color: red,
                          size: 0.014 * hei,
                        ),
                        Text(
                          donation.location.length > 10 
                              ? '${donation.location.substring(0, 10)}...' 
                              : donation.location,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 0.013 * hei,
                            color: red,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      DateFormat('HH:mm').format(donation.createdAt),
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 0.012 * hei,
                        color: red,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 0.01 * hei,
                margin: EdgeInsets.symmetric(horizontal: 0.02 * wid),
                child: LinearPercentIndicator(
                  animation: true,
                  animationDuration: 1000,
                  width: 0.46 * wid,
                  lineHeight: 4,
                  percent: donation.progressPercentage,
                  backgroundColor: Colors.grey[300],
                  progressColor: red,
                  barRadius: Radius.circular(2),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.03 * wid,
                  vertical: 0.004 * hei,
                ),
                child: Text(
                  donation.fundingGoal != null 
                      ? "₹ ${donation.currentFunding?.toStringAsFixed(0) ?? '0'}"
                      : "${donation.currentServed}/${donation.targetCount} served",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: red,
                    fontSize: 0.015 * hei,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNearbyRequestCard(DonationModel donation, double wid, double hei) {
    return Container(
      width: 0.4 * wid,
      margin: EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DonationDetailPage(donation: donation),
            ),
          );
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(0.02 * wid),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: donation.isActive ? Colors.green : Colors.grey,
                      size: 10,
                    ),
                    SizedBox(width: 4),
                    Text(
                      donation.isActive ? 'Active' : 'Completed',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 0.013 * hei,
                        color: donation.isActive ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  donation.title.length > 20 
                      ? '${donation.title.substring(0, 20)}...' 
                      : donation.title,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 0.015 * hei,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Location",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 0.012 * hei,
                    color: red,
                  ),
                ),
                Text(
                  donation.location,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 0.012 * hei,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Target",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 0.012 * hei,
                            color: red,
                          ),
                        ),
                        Text(
                          "${donation.adultsCount} A, ${donation.childrenCount} C",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 0.012 * hei,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Time",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 0.012 * hei,
                            color: red,
                          ),
                        ),
                        Text(
                          DateFormat('HH:mm').format(donation.createdAt),
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 0.012 * hei,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 0.03 * hei,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DonationDetailPage(donation: donation),
                        ),
                      );
                    },
                    child: Text(
                      "View Details",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 0.01 * hei,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
