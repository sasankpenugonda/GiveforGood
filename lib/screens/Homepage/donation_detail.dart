import 'package:flutter/material.dart';
import 'package:givelive/models/donation_model.dart';
import 'package:givelive/provider/donation_provider.dart';
import 'package:givelive/resuable/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DonationDetailPage extends StatefulWidget {
  final DonationModel donation;

  const DonationDetailPage({super.key, required this.donation});

  @override
  State<DonationDetailPage> createState() => _DonationDetailPageState();
}

class _DonationDetailPageState extends State<DonationDetailPage> {
  int _servedCount = 1;

  @override
  Widget build(BuildContext context) {
    double hei = MediaQuery.of(context).size.height;
    double wid = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: red),
        ),
        title: Text(
          'Donation Details',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 0.25 * hei,
              width: double.infinity,
              margin: EdgeInsets.all(0.04 * wid),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(widget.donation.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: widget.donation.isActive 
                            ? Colors.green 
                            : widget.donation.isCompleted 
                                ? red 
                                : Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.donation.isActive 
                            ? 'Active' 
                            : widget.donation.isCompleted 
                                ? 'Completed' 
                                : 'Expired',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(0.04 * wid),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Donor
                  Text(
                    widget.donation.title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, color: red, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'By ${widget.donation.donorName}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: red, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.donation.location,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 0.03 * hei),

                  // Progress Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${widget.donation.currentServed}/${widget.donation.targetCount}',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        LinearPercentIndicator(
                          width: wid * 0.82,
                          lineHeight: 8,
                          percent: widget.donation.progressPercentage,
                          backgroundColor: Colors.grey[300],
                          progressColor: red,
                          barRadius: Radius.circular(4),
                          animation: true,
                          animationDuration: 1000,
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            _buildStatCard('Adults', widget.donation.adultsCount.toString()),
                            SizedBox(width: 16),
                            _buildStatCard('Children', widget.donation.childrenCount.toString()),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 0.03 * hei),

                  // Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.donation.description,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 0.03 * hei),

                  // Time Information
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Created:',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy, hh:mm a').format(widget.donation.createdAt),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Expires:',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy, hh:mm a').format(widget.donation.expiresAt),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                color: widget.donation.isExpired ? red : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Funding section if applicable
                  if (widget.donation.fundingGoal != null) ...[
                    SizedBox(height: 0.03 * hei),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fundraising Goal',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '₹${widget.donation.currentFunding?.toStringAsFixed(0) ?? '0'} / ₹${widget.donation.fundingGoal?.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          LinearPercentIndicator(
                            width: wid * 0.82,
                            lineHeight: 6,
                            percent: (widget.donation.currentFunding ?? 0) / (widget.donation.fundingGoal ?? 1),
                            backgroundColor: Colors.grey[300],
                            progressColor: Colors.blue,
                            barRadius: Radius.circular(3),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (widget.donation.isActive) ...[
                    SizedBox(height: 0.03 * hei),
                    _buildActionSection(),
                  ],

                  SizedBox(height: 0.1 * hei),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: red,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSection() {
    double wid = MediaQuery.of(context).size.width;
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Help with this request',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text(
                'People served:',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => setState(() {
                        if (_servedCount > 1) _servedCount--;
                      }),
                      icon: Icon(Icons.remove, color: red),
                    ),
                    Text(
                      _servedCount.toString(),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _servedCount++),
                      icon: Icon(Icons.add, color: red),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _updateProgress(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Update Progress',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _completeDonation(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Mark Complete',
                    style: TextStyle(
                      color: red,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateProgress() {
    final provider = Provider.of<DonationProvider>(context, listen: false);
    provider.updateDonationProgress(
      donationId: widget.donation.id,
      servedCount: _servedCount,
      context: context,
    );
  }

  void _completeDonation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Complete Donation'),
        content: Text('Are you sure you want to mark this donation as completed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final provider = Provider.of<DonationProvider>(context, listen: false);
              provider.completeDonation(
                donationId: widget.donation.id,
                context: context,
              );
            },
            child: Text('Complete', style: TextStyle(color: red)),
          ),
        ],
      ),
    );
  }
}