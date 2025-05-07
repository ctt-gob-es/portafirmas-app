import 'package:app_factory_ui/buttons/af_buttons_lib.dart';
import 'package:app_factory_ui/labels/af_label.dart';
import 'package:app_factory_ui/theme/enums/af_component_theme.dart';
import 'package:flutter/material.dart';
import 'package:portafirmas_app/app/constants/assets.dart';
import 'package:portafirmas_app/data/models/sign_doc_petition_remote_entity.dart';
import 'package:portafirmas_app/data/models/sign_request_cert_petition_remote_entity.dart';
import 'package:portafirmas_app/data/repositories/models/request_app_data.dart';
import 'package:portafirmas_app/domain/models/document_entity.dart';
import 'package:portafirmas_app/domain/models/enum_request_priority.dart';
import 'package:portafirmas_app/domain/models/enum_request_type.dart';
import 'package:portafirmas_app/domain/models/request_entity.dart';
import 'package:portafirmas_app/domain/models/sign_line_content_entity.dart';
import 'package:portafirmas_app/domain/models/sign_line_entity.dart';
import 'package:portafirmas_app/presentation/features/filters/models/enum_request_status.dart';
import 'package:portafirmas_app/presentation/features/filters/models/filter_init_data.dart';
import 'package:portafirmas_app/presentation/features/filters/models/request_filter.dart';
import 'package:portafirmas_app/presentation/features/settings/model/profile_model_helper.dart';
import 'package:portafirmas_app/presentation/features/settings/widgets/customized_user_header.dart';
import 'package:portafirmas_app/presentation/features/settings/widgets/profile_template_push_notification.dart';
import 'package:portafirmas_app/presentation/features/settings/widgets/profile_template_section.dart';
import 'package:portafirmas_app/presentation/widget/clear_button.dart';
import 'package:portafirmas_app/presentation/widget/expanded_button.dart';
import 'package:portafirmas_app/presentation/widget/modal_template.dart';

class WidgetsInstruments {
  static const String mainButtonText = 'mainButtonText';
  static const String secondaryButtonText = 'secondaryButtonText';
  static const String headerText = 'header';
  static const String welcomeKey = 'welcome_tour';
  static const String inputText = 'signContent1';
  static const fall = 'CASCADA';
  static const parallel = 'PARALELO';
  static const annexe = 'Annexe';
  static const searchNewAuthorized = 'Invitados A Firmar';
  static const String inputText2 = 'Hannah';
  static const String leftIcon = Assets.iconUser;
  static const String rightIcon = Assets.iconChevronRight;
  static String information = 'information';
  static String certificate = 'EIDAS_CERTIFICADO_9999R.p12';
  static AFLabel label = const AFLabel.error(text: 'error label');
  static const String testText = 'Test';
  static List<ProfileModelHelper> contentList = [
    ProfileModelHelper(
      text: inputText,
      leftIcon: leftIcon,
      rightIcon: rightIcon,
      onTap: () => DoNothingAction(),
      label: label,
      information: information,
    ),
    ProfileModelHelper(
      text: inputText2,
      leftIcon: leftIcon,
      label: label,
      onSwitchChange: (value) => DoNothingAction(),
      switchValue: false,
      onTap: () => DoNothingAction(),
    ),
  ];

  static SignLineEntity getSignLineEntity() => const SignLineEntity(
        signName: [
          SignLineContentEntity(signContent: 'signContent1'),
          SignLineContentEntity(signContent: 'signContent2'),
        ],
        type: 'FIRMA',
      );

  static ModalTemplate getModalTemplate() => ModalTemplate(
        isReverse: false,
        mainButtonText: mainButtonText,
        secondaryButtonText: secondaryButtonText,
        header: headerText,
        iconPath: Assets.iconClave,
        mainButtonFunction: () => DoNothingAction(),
        isFantasma: true,
        secondaryButtonFunction: () => DoNothingAction(),
        moreChildrens: [
          Container(),
        ],
      );

  static ExpandedButton getExpandedButton(bool isTertiary) => ExpandedButton(
        isTertiary: isTertiary,
        text: mainButtonText,
        size: AFButtonSize.m,
        onTap: () => DoNothingAction(),
        iconRight: Assets.iconChevronLeft,
      );

  static ClearButton getClearButton() => ClearButton(
        text: mainButtonText,
        size: AFButtonSize.m,
        onTap: () => DoNothingAction(),
      );

  static RequestAppData getRequestAppData() =>
      const RequestAppData(id: '0', name: 'example app 0');

  static List<RequestAppData> getRequestAppDataList() => List.generate(
        3,
        (index) => RequestAppData(id: '$index', name: 'example app $index'),
      );

  static List<DocumentEntity> documentEntityList() => List.generate(
        2,
        (index) => DocumentEntity(
          docId: 'docId$index',
          docName: 'ANEXO',
          docSize: '13900',
          signAlgo: 'signAlgo',
          signFrmt: 'signFrmt',
          params: '',
        ),
      );

  static RequestEntity detailRequestResponse(String signLinesType) =>
      RequestEntity(
        id: 'id',
        from: 'sender',
        subject: 'info',
        ref: 'ref',
        application: 'application',
        lastModificationDate: DateTime.now(),
        type: RequestType.signature,
        expirationDate: DateTime(2024, 10, 10, 09, 33, 21),
        priority: RequestPriority.high,
        signLinesType: signLinesType,
        signLines: const [
          SignLineEntity(
            type: 'FIRMA',
            signName: [
              SignLineContentEntity(signContent: 'signContent1'),
              SignLineContentEntity(signContent: 'signContent2'),
            ],
          ),
        ],
        listDocs: documentEntityList(),
      );

  static ProfileTemplatePushNotifications getPushWidget(
    bool value,
    Function(bool) onSwitchChange,
  ) =>
      ProfileTemplatePushNotifications(
        leftIcon: Assets.iconBell,
        onSwitchChange: onSwitchChange,
        switchValue: value,
        text: mainButtonText,
      );

  static ProfileTemplateSection getProfileTemplateSection() =>
      ProfileTemplateSection(
        contentList: contentList,
      );

  static AFHeaderProcessCustomized getAFheaderProcess() =>
      AFHeaderProcessCustomized(
        title: inputText,
        caption: certificate,
        iconAsset: Assets.iconUserCircle,
        themeComponent: AFThemeComponent.light,
      );

  static SizedBox getValidatorButton() => SizedBox(
        width: double.infinity,
        child: AFButton.secondary(
          onPressed: () => DoNothingAction(),
          text: mainButtonText,
          enabled: true,
          sizeButton: AFButtonSize.l,
        ),
      );

  static FilterInitData givenFilterInitData() => FilterInitData(
        requestStatus: RequestStatus.pending,
        initFilter: RequestFilter.initial(),
        isValidatorProfile: false,
      );

  static SignRequestPetitionRemoteEntity givenSignReqPetitionRemoteEntity() =>
      SignRequestPetitionRemoteEntity(
        requestId: 'requestId',
        signDocs: List.generate(
          2,
          (index) => SignDocPetitionRemoteEntity(
            docId: 'docId_$index',
            signFrmt: 'PDF',
            signAlgo: 'SHA1',
            params: '',
          ),
        ),
      );

  static RequestEntity givenDetailRequestEntity() => RequestEntity(
        id: 'id',
        from: 'sender',
        subject: 'info',
        ref: 'ref',
        application: 'application',
        lastModificationDate: DateTime.now(),
        expirationDate: DateTime.now(),
        signLinesType: 'signLinesType',
        signLines: [],
        type: RequestType.signature,
        listDocs: documentEntityList(),
        priority: RequestPriority.high,
      );
}
