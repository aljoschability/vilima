/**
 */
package com.aljoschability.vilima.provider;


import com.aljoschability.vilima.MkvFile;
import com.aljoschability.vilima.VilimaFactory;
import com.aljoschability.vilima.VilimaPackage;

import java.util.Collection;
import java.util.List;

import org.eclipse.emf.common.notify.AdapterFactory;
import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.common.util.ResourceLocator;

import org.eclipse.emf.ecore.EStructuralFeature;

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
 * This is the item provider adapter for a {@link com.aljoschability.vilima.MkvFile} object.
 * <!-- begin-user-doc -->
 * <!-- end-user-doc -->
 * @generated
 */
public class MkvFileItemProvider 
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
	public MkvFileItemProvider(AdapterFactory adapterFactory) {
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

			addFilePathPropertyDescriptor(object);
			addFileNamePropertyDescriptor(object);
			addFileSizePropertyDescriptor(object);
			addFileDatePropertyDescriptor(object);
			addSegmentUidPropertyDescriptor(object);
			addSegmentPreviousUidPropertyDescriptor(object);
			addSegmentNextUidPropertyDescriptor(object);
			addSegmentTimecodeScalePropertyDescriptor(object);
			addSegmentDurationPropertyDescriptor(object);
			addSegmentDatePropertyDescriptor(object);
			addSegmentTitlePropertyDescriptor(object);
			addSegmentMuxingAppPropertyDescriptor(object);
			addSegmentWritingAppPropertyDescriptor(object);
		}
		return itemPropertyDescriptors;
	}

	/**
	 * This adds a property descriptor for the File Path feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addFilePathPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvFile_filePath_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvFile_filePath_feature", "_UI_MkvFile_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_FILE__FILE_PATH,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.GENERIC_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the File Name feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addFileNamePropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvFile_fileName_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvFile_fileName_feature", "_UI_MkvFile_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_FILE__FILE_NAME,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.GENERIC_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the File Size feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addFileSizePropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvFile_fileSize_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvFile_fileSize_feature", "_UI_MkvFile_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_FILE__FILE_SIZE,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.INTEGRAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the File Date feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addFileDatePropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvFile_fileDate_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvFile_fileDate_feature", "_UI_MkvFile_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_FILE__FILE_DATE,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.INTEGRAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Segment Uid feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addSegmentUidPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvFile_segmentUid_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvFile_segmentUid_feature", "_UI_MkvFile_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_FILE__SEGMENT_UID,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.GENERIC_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Segment Previous Uid feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addSegmentPreviousUidPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvFile_segmentPreviousUid_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvFile_segmentPreviousUid_feature", "_UI_MkvFile_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_FILE__SEGMENT_PREVIOUS_UID,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.GENERIC_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Segment Next Uid feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addSegmentNextUidPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvFile_segmentNextUid_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvFile_segmentNextUid_feature", "_UI_MkvFile_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_FILE__SEGMENT_NEXT_UID,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.GENERIC_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Segment Timecode Scale feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addSegmentTimecodeScalePropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvFile_segmentTimecodeScale_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvFile_segmentTimecodeScale_feature", "_UI_MkvFile_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_FILE__SEGMENT_TIMECODE_SCALE,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.INTEGRAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Segment Duration feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addSegmentDurationPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvFile_segmentDuration_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvFile_segmentDuration_feature", "_UI_MkvFile_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_FILE__SEGMENT_DURATION,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.INTEGRAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Segment Date feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addSegmentDatePropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvFile_segmentDate_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvFile_segmentDate_feature", "_UI_MkvFile_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_FILE__SEGMENT_DATE,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.INTEGRAL_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Segment Title feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addSegmentTitlePropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvFile_segmentTitle_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvFile_segmentTitle_feature", "_UI_MkvFile_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_FILE__SEGMENT_TITLE,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.GENERIC_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Segment Muxing App feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addSegmentMuxingAppPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvFile_segmentMuxingApp_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvFile_segmentMuxingApp_feature", "_UI_MkvFile_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_FILE__SEGMENT_MUXING_APP,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.GENERIC_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This adds a property descriptor for the Segment Writing App feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addSegmentWritingAppPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MkvFile_segmentWritingApp_feature"), //$NON-NLS-1$
				 getString("_UI_PropertyDescriptor_description", "_UI_MkvFile_segmentWritingApp_feature", "_UI_MkvFile_type"), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
				 VilimaPackage.Literals.MKV_FILE__SEGMENT_WRITING_APP,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.GENERIC_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This specifies how to implement {@link #getChildren} and is used to deduce an appropriate feature for an
	 * {@link org.eclipse.emf.edit.command.AddCommand}, {@link org.eclipse.emf.edit.command.RemoveCommand} or
	 * {@link org.eclipse.emf.edit.command.MoveCommand} in {@link #createCommand}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Collection<? extends EStructuralFeature> getChildrenFeatures(Object object) {
		if (childrenFeatures == null) {
			super.getChildrenFeatures(object);
			childrenFeatures.add(VilimaPackage.Literals.MKV_FILE__TRACKS);
			childrenFeatures.add(VilimaPackage.Literals.MKV_FILE__TAGS);
			childrenFeatures.add(VilimaPackage.Literals.MKV_FILE__ATTACHMENTS);
			childrenFeatures.add(VilimaPackage.Literals.MKV_FILE__CHAPTERS);
		}
		return childrenFeatures;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EStructuralFeature getChildFeature(Object object, Object child) {
		// Check the type of the specified child object and return the proper feature to use for
		// adding (see {@link AddCommand}) it as a child.

		return super.getChildFeature(object, child);
	}

	/**
	 * This returns MkvFile.gif.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object getImage(Object object) {
		return overlayImage(object, getResourceLocator().getImage("full/obj16/MkvFile")); //$NON-NLS-1$
	}

	/**
	 * This returns the label text for the adapted class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getText(Object object) {
		String label = ((MkvFile)object).getFileName();
		return label == null || label.length() == 0 ?
			getString("_UI_MkvFile_type") : //$NON-NLS-1$
			getString("_UI_MkvFile_type") + " " + label; //$NON-NLS-1$ //$NON-NLS-2$
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

		switch (notification.getFeatureID(MkvFile.class)) {
			case VilimaPackage.MKV_FILE__FILE_PATH:
			case VilimaPackage.MKV_FILE__FILE_NAME:
			case VilimaPackage.MKV_FILE__FILE_SIZE:
			case VilimaPackage.MKV_FILE__FILE_DATE:
			case VilimaPackage.MKV_FILE__SEGMENT_UID:
			case VilimaPackage.MKV_FILE__SEGMENT_PREVIOUS_UID:
			case VilimaPackage.MKV_FILE__SEGMENT_NEXT_UID:
			case VilimaPackage.MKV_FILE__SEGMENT_TIMECODE_SCALE:
			case VilimaPackage.MKV_FILE__SEGMENT_DURATION:
			case VilimaPackage.MKV_FILE__SEGMENT_DATE:
			case VilimaPackage.MKV_FILE__SEGMENT_TITLE:
			case VilimaPackage.MKV_FILE__SEGMENT_MUXING_APP:
			case VilimaPackage.MKV_FILE__SEGMENT_WRITING_APP:
				fireNotifyChanged(new ViewerNotification(notification, notification.getNotifier(), false, true));
				return;
			case VilimaPackage.MKV_FILE__TRACKS:
			case VilimaPackage.MKV_FILE__TAGS:
			case VilimaPackage.MKV_FILE__ATTACHMENTS:
			case VilimaPackage.MKV_FILE__CHAPTERS:
				fireNotifyChanged(new ViewerNotification(notification, notification.getNotifier(), true, false));
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

		newChildDescriptors.add
			(createChildParameter
				(VilimaPackage.Literals.MKV_FILE__TRACKS,
				 VilimaFactory.eINSTANCE.createMkvTrack()));

		newChildDescriptors.add
			(createChildParameter
				(VilimaPackage.Literals.MKV_FILE__TAGS,
				 VilimaFactory.eINSTANCE.createMkvTag()));

		newChildDescriptors.add
			(createChildParameter
				(VilimaPackage.Literals.MKV_FILE__ATTACHMENTS,
				 VilimaFactory.eINSTANCE.createMkvAttachment()));

		newChildDescriptors.add
			(createChildParameter
				(VilimaPackage.Literals.MKV_FILE__CHAPTERS,
				 VilimaFactory.eINSTANCE.createMkvChapter()));
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
