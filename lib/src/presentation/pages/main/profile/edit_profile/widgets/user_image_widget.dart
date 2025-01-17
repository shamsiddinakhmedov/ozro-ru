import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ozro_mobile/src/core/extension/extension.dart';
import 'package:ozro_mobile/src/core/utils/utils.dart';
import 'package:ozro_mobile/src/presentation/components/image_network/custom_cached_network_image.dart';

class UserImageWidget extends StatelessWidget {
  const UserImageWidget({
    super.key,
    required this.imageUrl,
    required this.defaultWord,
    required this.onTap,
    this.imageFile,
  });

  final String imageUrl;
  final File? imageFile;
  final String defaultWord;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Center(
        child: SizedBox(
          height: 104,
          width: 104,
          child: Stack(
            children: [
              // USER IMAGE
              Positioned.fill(
                child: SizedBox(
                  child: Hero(
                    tag: const ValueKey('user_photo'),
                    child: imageFile != null
                        ? ClipRRect(
                            borderRadius: AppUtils.kBorderRadius100,
                            child: Image.file(
                              imageFile!,
                              fit: BoxFit.cover,
                              height: 104,
                            ),
                          )
                        : CustomCachedNetworkImage(
                            borderRadius: AppUtils.kBorderRadius100,
                            defaultWord: defaultWord,
                            imageUrl: imageUrl,
                            height: 104,
                          ),
                  ),
                ),
              ),

              /// CHOOSE IMAGE BUTTON
              Positioned(
                right: 0,
                bottom: 0,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: AppUtils.kBorderRadius12,
                    child: Ink(
                      height: 32,
                      width: 32,
                      // padding: AppUtils.kPaddingAll4,
                      decoration: BoxDecoration(
                        color: context.color.white,
                        borderRadius: AppUtils.kBorderRadius12,
                        border: Border.all(
                          color: context.color.black.withOpacity(0.1),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          AppIcons.camera,
                          // size: 18,
                          color: context.color.midGrey4,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
