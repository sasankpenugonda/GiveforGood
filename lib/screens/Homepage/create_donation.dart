import 'package:flutter/material.dart';
import 'package:givelive/provider/donation_provider.dart';
import 'package:givelive/resuable/colors.dart';
import 'package:provider/provider.dart';

class CreateDonationPage extends StatefulWidget {
  const CreateDonationPage({super.key});

  @override
  State<CreateDonationPage> createState() => _CreateDonationPageState();
}

class _CreateDonationPageState extends State<CreateDonationPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _fundingGoalController = TextEditingController();
  
  int _adultsCount = 0;
  int _childrenCount = 0;
  DateTime _expiresAt = DateTime.now().add(const Duration(days: 7));
  bool _isFundraising = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    _fundingGoalController.dispose();
    super.dispose();
  }

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
          'Create Donation Request',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(0.04 * wid),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Basic Information'),
              _buildTextField(
                controller: _titleController,
                label: 'Title',
                hint: 'e.g., Food needed for 50 people',
                validator: (value) => value?.isEmpty == true ? 'Title is required' : null,
              ),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe the situation and what help is needed',
                maxLines: 3,
                validator: (value) => value?.isEmpty == true ? 'Description is required' : null,
              ),
              _buildTextField(
                controller: _locationController,
                label: 'Location',
                hint: 'e.g., T Nagar, Chennai',
                validator: (value) => value?.isEmpty == true ? 'Location is required' : null,
              ),
              
              SizedBox(height: 0.02 * hei),
              _buildSectionTitle('Target People'),
              Row(
                children: [
                  Expanded(child: _buildCounterWidget('Adults', _adultsCount, (count) {
                    setState(() => _adultsCount = count);
                  })),
                  SizedBox(width: 0.04 * wid),
                  Expanded(child: _buildCounterWidget('Children', _childrenCount, (count) {
                    setState(() => _childrenCount = count);
                  })),
                ],
              ),

              SizedBox(height: 0.02 * hei),
              _buildSectionTitle('Expiry Date'),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Expires on: ${_expiresAt.day}/${_expiresAt.month}/${_expiresAt.year}',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                trailing: Icon(Icons.calendar_today, color: red),
                onTap: _selectDate,
              ),

              SizedBox(height: 0.02 * hei),
              _buildSectionTitle('Additional Options'),
              
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Enable Fundraising',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                subtitle: Text(
                  'Allow people to donate money instead of food',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 12),
                ),
                value: _isFundraising,
                activeColor: red,
                onChanged: (value) => setState(() => _isFundraising = value),
              ),

              if (_isFundraising)
                _buildTextField(
                  controller: _fundingGoalController,
                  label: 'Funding Goal (₹)',
                  hint: 'e.g., 5000',
                  keyboardType: TextInputType.number,
                ),

              _buildTextField(
                controller: _imageUrlController,
                label: 'Image URL (Optional)',
                hint: 'https://example.com/image.jpg',
              ),

              SizedBox(height: 0.04 * hei),
              SizedBox(
                width: double.infinity,
                height: 0.06 * hei,
                child: ElevatedButton(
                  onPressed: _createDonation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Consumer<DonationProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return CircularProgressIndicator(color: Colors.white);
                      }
                      return Text(
                        'Create Request',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.01 * MediaQuery.of(context).size.height),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.02 * MediaQuery.of(context).size.height),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 0.005 * MediaQuery.of(context).size.height),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterWidget(String label, int count, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => count > 0 ? onChanged(count - 1) : null,
                icon: Icon(Icons.remove, color: count > 0 ? red : Colors.grey),
              ),
              Text(
                count.toString(),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                onPressed: () => onChanged(count + 1),
                icon: Icon(Icons.add, color: red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _expiresAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _expiresAt = date);
    }
  }

  void _createDonation() {
    if (!_formKey.currentState!.validate()) return;
    if (_adultsCount == 0 && _childrenCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please specify at least one adult or child')),
      );
      return;
    }

    final provider = Provider.of<DonationProvider>(context, listen: false);
    provider.createDonation(
      context: context,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      adultsCount: _adultsCount,
      childrenCount: _childrenCount,
      expiresAt: _expiresAt,
      imageUrl: _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text.trim(),
      fundingGoal: _isFundraising && _fundingGoalController.text.isNotEmpty 
          ? double.tryParse(_fundingGoalController.text) 
          : null,
    ).then((_) {
      Navigator.pop(context);
    });
  }
}