import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/core/theme/widgets/starry_background.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: SpaceTheme.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Uzaycık Aboneliği',
          style: SpaceTheme.titleStyle.copyWith(fontSize: 24),
        ),
      ),
      body: Stack(
        fit: StackFit.expand, 
        children: [
          StarryBackground(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: context.paddingNormal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: context.getDynamicHeight(2)),
                    _buildHeader(context),
                    SizedBox(height: context.getDynamicHeight(3)),
                    _buildBenefits(context),
                    SizedBox(height: context.getDynamicHeight(1)),
                    _buildPricing(context),
                    SizedBox(height: context.getDynamicHeight(3)),
                    _buildSubscribeButton(context),
                    SizedBox(height: context.getDynamicHeight(2)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.star,
          size: 80,
          color: SpaceTheme.accentGold,
          shadows: [
            Shadow(color: SpaceTheme.accentPurple, blurRadius: 15),
          ],
        ),
        SizedBox(height: context.getDynamicHeight(2)),
        Text(
          'Galaksiye Özel Erişim!',
          style: SpaceTheme.titleStyle.copyWith(
            fontSize: 28,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: context.getDynamicHeight(1)),
        Text(
          'Uzaycık Masalları ile sınırsız masal yarat, yıldızlarla dolu bir dünyaya katıl!',
          style: TextStyle(
            color: Colors.white.withValues(alpha:0.8),
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBenefits(BuildContext context) {
    final benefits = [
      {'text': 'Sınırsız Masal Oluşturma', 'icon': Icons.auto_awesome},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: benefits.map((benefit) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                benefit['icon'] as IconData,
                color: SpaceTheme.accentGold,
                size: 30,
              ),
              SizedBox(width: context.getDynamicWidth(3)),
              Text(
                benefit['text'] as String,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPricing(BuildContext context) {
    return Text(
      '29.99 TL / Aylık',
      style: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubscribeButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Abone olma işlemi başlatıldı!'),
            backgroundColor: SpaceTheme.accentPurple,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: SpaceTheme.accentPurple,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 5,
        shadowColor: SpaceTheme.accentPurple.withValues(alpha:0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: SpaceTheme.accentGold,
            size: 24,
          ),
          SizedBox(width: context.getDynamicWidth(2)),
          Text(
            'Abone Ol!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

