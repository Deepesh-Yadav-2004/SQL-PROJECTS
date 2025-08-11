-- Cleaning Data in SQL Queries

Select *
From NashvilleHousing

-- Standardize Date Format

Select saledateconverted, Convert(date,saledate)
from NashvilleHousing


update NashvilleHousing
set SaleDate = CONVERT(date,saledate)

alter table NashvilleHousing
add saledateconverted date

update NashvilleHousing
set saledateconverted = CONVERT(date,saledate)


-- Populate Property Address Data

Select *
from NashvilleHousing
Order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
and	a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


Update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
and	a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out Address into individual columns (Address, City, State)

select propertyaddress
from NashvilleHousing

Select 
SUBSTRING(propertyaddress,1, CHARINDEX(',',propertyaddress) -1) as Address,
SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress) +1,LEN(propertyaddress))  as Address
from NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar(255)

Update NashvilleHousing
set PropertySplitAddress = SUBSTRING(propertyaddress,1, CHARINDEX(',',propertyaddress) -1)

Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(255)

Update NashvilleHousing
set PropertySplitCity = SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress) +1,LEN(propertyaddress))

Select *
From NashvilleHousing


Select OwnerAddress
from NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
from NashvilleHousing

Alter Table NashvilleHousing
Add OwnerSplitAddress nvarchar(255)

Update NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

Alter Table NashvilleHousing
Add OwnerSplitCity nvarchar(255)

Update NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

Alter Table NashvilleHousing
Add OwnerSplitState nvarchar(255)

Update NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

Select *
From NashvilleHousing

------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to yes and no in "Sold as Vacant" Field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
CASE when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 end
From NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 end

Select *
From NashvilleHousing

----------------------------------------------------------------------------------------------------------

-- Remove Duplicates

With RowNumCTE AS(
Select *,
	ROW_NUMBER() Over(
	Partition By parcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 Order by uniqueID
				 ) row_num

From NashvilleHousing
)
select *
from RowNumCTE
where row_num > 1
--order by propertyaddress

------------------------------------------------------------------------------------------------------

--Deleted Used Columns


Select *
From NashvilleHousing

Alter Table NashvilleHousing
Drop column owneraddress, Taxdistrict,propertyaddress,saledate