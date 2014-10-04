/**
 */
package com.aljoschability.vilima.provider;


import com.aljoschability.vilima.MkvTrack;
import com.aljoschability.vilima.VilimaPackage;

import java.util.Collection;
import java.util.List;

import org.eclipse.emf.common.notify.AdapterFactory;
import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.common.util.ResourceLocator;

import org.eclipse.emf.edit.provider.ComposeableAdapterFactory;
import org.eclipse.emf.edit.provider.IEditingDomainItemProvider;
import org.eclipse.emf.edit.provider.IItemLabelProvider;
import org.eclipse.emf.edit.provider.IItemPropertyDescriptor;
import org.eclipse.emf.edit.provider.IItemPropertySource;
import org.eclipse.emf.edit.provider.IStructuredItemContentProvider;
import org.eclipse.emf.edit.provider.ITreeItemContentProvider;
import org.eclipse.emf.edit.provider.ItemPropertyDescriptor;
import org.eclipse.emf.edit.provider.ItemProviderAdapter;
import org.eclipse.emf.edit.provider.ViewerNotification;

/**
 * This is the item provider adapter for a {@link com.aljoschability.vilima.MkvTrack} object.
 * <!-- begin-user-doc -->
 * <!-- end-user-doc -->
 * @generated
 */
public class MkvTrackItemProvider 
	extends ItemProviderAdapter
	implements
		IEditingDomainItemProvider,
		IStructuredItemContentProvider,
		ITreeItemContentProvider,
		IItemLabelProvider,
		IItemPropertySource {
	/**
	 * This constructs an instance from a factory and a notifier.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public MkvTrackItemProvider(AdapterFactory adapterFactory) {
		super(adapterFactory);
	}

	/**
	 * This returns the property descriptors for the adapted class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public List<IItemPropertyDescriptor> getPropertyDescriptors(Object object) {
		if (itemPropertyDescriptors == null) {
			super.getPropertyDescriptors(object);

			addNumberPropertyDescriptor(object);
			addUidPropertyDescriptor(object);
			addTypePropertyDescriptor(object);
			addFlagEnabledPropertyDescriptor(object);
			addFlagDefaultPropertyDescriptor(object);
			addFlagForcedPropertyDescriptor(object);
			addFlagLacingPropertyDescriptor(object);
			addNamePropertyDescriptor(object);
			addLanguagePropertyDescriptor(object);
			addCodecIdPropertyDescriptor(object);
			addCodecPrivatePropertyDescriptor(object);
			addCodecNamePropertyDescriptor(object);
			addVideoFlagInterlacedPropertyDescriptor(object);
			addVideoPixelWidthPropertyDescriptor(object);
			addVideoPixelHeightPropertyDescriptor(object);
			addVideoPixelCropBottomPropertyDescriptor(object);
			addVideoPixelCropTopPropertyDescriptor(object);
			addVideoPixelCropLeftPropertyDescriptor(object);
			addVideoPixelCropRightPropertyDescriptor(object);
			addVideoDisplayWidthPropertyDescriptor(object);
			addVideoDisplayHeightPropertyDescriptor(object);
			addVideoDisplayUnitPropertyDescriptor(object);
			addVideoAspectRatioTypePropertyDescriptor(object);
			addAudioSamplingFrequencyPropertyDescriptor(object);
			addAudioOutputSamplingFrequencyPropertyDescriptor(object);
			addAudioChannelsPropertyDescriptor(object);
		}
		return itemPropertyDescriptors;
	}

	/**
	 * This adds a property descriptor for the Number feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addNumberPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_number_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_number_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__NUMBER,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.INTEGRAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Uid feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addUidPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_uid_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_uid_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__UID,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.INTEGRAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Type feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addTypePropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_type_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_type_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__TYPE,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.GENERIC_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Flag Enabled feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addFlagEnabledPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_flagEnabled_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_flagEnabled_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__FLAG_ENABLED,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.BOOLEAN_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Flag Default feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addFlagDefaultPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_flagDefault_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_flagDefault_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__FLAG_DEFAULT,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.BOOLEAN_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Flag Forced feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addFlagForcedPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_flagForced_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_flagForced_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__FLAG_FORCED,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.BOOLEAN_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Flag Lacing feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addFlagLacingPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_flagLacing_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_flagLacing_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__FLAG_LACING,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.BOOLEAN_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Name feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addNamePropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_name_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_name_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__NAME,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.GENERIC_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Language feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addLanguagePropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_language_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_language_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__LANGUAGE,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.GENERIC_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Codec Id feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addCodecIdPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_codecId_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_codecId_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__CODEC_ID,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.GENERIC_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Codec Private feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addCodecPrivatePropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_codecPrivate_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_codecPrivate_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__CODEC_PRIVATE,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.GENERIC_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Codec Name feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addCodecNamePropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_codecName_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_codecName_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__CODEC_NAME,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.GENERIC_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Video Flag Interlaced feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addVideoFlagInterlacedPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_videoFlagInterlaced_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_videoFlagInterlaced_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__VIDEO_FLAG_INTERLACED,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.BOOLEAN_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Video Pixel Width feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addVideoPixelWidthPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_videoPixelWidth_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_videoPixelWidth_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__VIDEO_PIXEL_WIDTH,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.INTEGRAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Video Pixel Height feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addVideoPixelHeightPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_videoPixelHeight_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_videoPixelHeight_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__VIDEO_PIXEL_HEIGHT,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.INTEGRAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Video Pixel Crop Bottom feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addVideoPixelCropBottomPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_videoPixelCropBottom_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_videoPixelCropBottom_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__VIDEO_PIXEL_CROP_BOTTOM,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.INTEGRAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Video Pixel Crop Top feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addVideoPixelCropTopPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_videoPixelCropTop_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_videoPixelCropTop_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__VIDEO_PIXEL_CROP_TOP,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.INTEGRAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Video Pixel Crop Left feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addVideoPixelCropLeftPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_videoPixelCropLeft_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_videoPixelCropLeft_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__VIDEO_PIXEL_CROP_LEFT,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.INTEGRAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Video Pixel Crop Right feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addVideoPixelCropRightPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_videoPixelCropRight_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_videoPixelCropRight_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__VIDEO_PIXEL_CROP_RIGHT,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.INTEGRAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Video Display Width feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addVideoDisplayWidthPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_videoDisplayWidth_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_videoDisplayWidth_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__VIDEO_DISPLAY_WIDTH,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.INTEGRAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Video Display Height feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addVideoDisplayHeightPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_videoDisplayHeight_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_videoDisplayHeight_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__VIDEO_DISPLAY_HEIGHT,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.INTEGRAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Video Display Unit feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addVideoDisplayUnitPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_videoDisplayUnit_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_videoDisplayUnit_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__VIDEO_DISPLAY_UNIT,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.INTEGRAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Video Aspect Ratio Type feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addVideoAspectRatioTypePropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_videoAspectRatioType_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_videoAspectRatioType_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__VIDEO_ASPECT_RATIO_TYPE,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.INTEGRAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Audio Sampling Frequency feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addAudioSamplingFrequencyPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_audioSamplingFrequency_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_audioSamplingFrequency_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__AUDIO_SAMPLING_FREQUENCY,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.REAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Audio Output Sampling Frequency feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addAudioOutputSamplingFrequencyPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_audioOutputSamplingFrequency_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_audioOutputSamplingFrequency_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__AUDIO_OUTPUT_SAMPLING_FREQUENCY,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.REAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Audio Channels feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addAudioChannelsPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvTrack_audioChannels_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvTrack_audioChannels_feature", "_UI_MkvTrack_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_TRACK__AUDIO_CHANNELS,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.INTEGRAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This returns MkvTrack.gif.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object getImage(Object object) {
		return overlayImage(object, getResourceLocator().getImage("full/obj16/MkvTrack")); //$NON-NLS-1$
	}

	/**
	 * This returns the label text for the adapted class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getText(Object object) {
		String label = ((MkvTrack)object).getName();
		return label == null || label.length() == 0 ?
			getString("_UI_MkvTrack_type") : //$NON-NLS-1$
			getString("_UI_MkvTrack_type") + " " + label; //$NON-NLS-1$ //$NON-NLS-2$
	}
	

	/**
	 * This handles model notifications by calling {@link #updateChildren} to update any cached
	 * children and by creating a viewer notification, which it passes to {@link #fireNotifyChanged}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void notifyChanged(Notification notification) {
		updateChildren(notification);

		switch (notification.getFeatureID(MkvTrack.class)) {
			case VilimaPackage.MKV_TRACK__NUMBER:
			case VilimaPackage.MKV_TRACK__UID:
			case VilimaPackage.MKV_TRACK__TYPE:
			case VilimaPackage.MKV_TRACK__FLAG_ENABLED:
			case VilimaPackage.MKV_TRACK__FLAG_DEFAULT:
			case VilimaPackage.MKV_TRACK__FLAG_FORCED:
			case VilimaPackage.MKV_TRACK__FLAG_LACING:
			case VilimaPackage.MKV_TRACK__NAME:
			case VilimaPackage.MKV_TRACK__LANGUAGE:
			case VilimaPackage.MKV_TRACK__CODEC_ID:
			case VilimaPackage.MKV_TRACK__CODEC_PRIVATE:
			case VilimaPackage.MKV_TRACK__CODEC_NAME:
			case VilimaPackage.MKV_TRACK__VIDEO_FLAG_INTERLACED:
			case VilimaPackage.MKV_TRACK__VIDEO_PIXEL_WIDTH:
			case VilimaPackage.MKV_TRACK__VIDEO_PIXEL_HEIGHT:
			case VilimaPackage.MKV_TRACK__VIDEO_PIXEL_CROP_BOTTOM:
			case VilimaPackage.MKV_TRACK__VIDEO_PIXEL_CROP_TOP:
			case VilimaPackage.MKV_TRACK__VIDEO_PIXEL_CROP_LEFT:
			case VilimaPackage.MKV_TRACK__VIDEO_PIXEL_CROP_RIGHT:
			case VilimaPackage.MKV_TRACK__VIDEO_DISPLAY_WIDTH:
			case VilimaPackage.MKV_TRACK__VIDEO_DISPLAY_HEIGHT:
			case VilimaPackage.MKV_TRACK__VIDEO_DISPLAY_UNIT:
			case VilimaPackage.MKV_TRACK__VIDEO_ASPECT_RATIO_TYPE:
			case VilimaPackage.MKV_TRACK__AUDIO_SAMPLING_FREQUENCY:
			case VilimaPackage.MKV_TRACK__AUDIO_OUTPUT_SAMPLING_FREQUENCY:
			case VilimaPackage.MKV_TRACK__AUDIO_CHANNELS:
				fireNotifyChanged(new ViewerNotification(notification, notification.getNotifier(), false, true));
				return;
		}
		super.notifyChanged(notification);
	}

	/**
	 * This adds {@link org.eclipse.emf.edit.command.CommandParameter}s describing the children
	 * that can be created under this object.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected void collectNewChildDescriptors(Collection<Object> newChildDescriptors, Object object) {
		super.collectNewChildDescriptors(newChildDescriptors, object);
	}

	/**
	 * Return the resource locator for this item provider's resources.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public ResourceLocator getResourceLocator() {
		return VilimaEditPlugin.INSTANCE;
	}

}
