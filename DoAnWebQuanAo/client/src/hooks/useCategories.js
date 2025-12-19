// client/src/hooks/useCategories.js
import { useState, useCallback, useContext } from 'react';
import { toast } from 'react-toastify';
import slugify from 'slugify';
import AuthContext from '../context/AuthContext';

export const useCategories = () => {
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { api } = useContext(AuthContext);

  const fetchCategories = useCallback(async () => {
    setLoading(true);
    try {
      const { data } = await api.get('/categories');
      setCategories(data);
      setError(null);
    } catch (err) {
      const errMsg = 'Không thể tải danh sách danh mục.';
      setError(errMsg);
      toast.error(errMsg);
      console.error('Error fetching categories:', err);
    } finally {
      setLoading(false);
    }
  }, [api]);

  const addCategory = async (categoryData) => {
    const dataToSend = {
      ...categoryData,
      Slug:
        categoryData.Slug.trim() ||
        slugify(categoryData.TenDanhMuc, { lower: true, locale: 'vi', remove: /[*+~.()'"!:@]/g }),
      DanhMucChaID: categoryData.DanhMucChaID || null,
    };

    const response = await api.post('/categories', dataToSend);
    toast.success(response.data.message);
    fetchCategories(); // Refresh list
  };

  const updateCategory = async (categoryId, categoryData) => {
    const dataToSend = {
      ...categoryData,
      Slug:
        categoryData.Slug.trim() ||
        slugify(categoryData.TenDanhMuc, { lower: true, locale: 'vi', remove: /[*+~.()'"!:@]/g }),
      DanhMucChaID: categoryData.DanhMucChaID || null,
    };
    
    const response = await api.put(`/categories/${categoryId}`, dataToSend);
    toast.success(response.data.message);
    fetchCategories(); // Refresh list
  };

  const deleteCategory = async (categoryId) => {
    const response = await api.delete(`/categories/${categoryId}`);
    toast.success(response.data.message);
    fetchCategories(); // Refresh list
  };
  
  // Helper to build category tree
  const buildCategoryTree = (categoryList) => {
    const map = {};
    const tree = [];
    categoryList.forEach((cat) => {
        map[cat.DanhMucID] = { ...cat, children: [] };
    });
    Object.values(map).forEach((cat) => {
        if (cat.DanhMucChaID) {
            if (map[cat.DanhMucChaID]) {
                map[cat.DanhMucChaID].children.push(cat);
            }
        } else {
            tree.push(cat);
        }
    });
    return tree;
  };

  return {
    categories,
    loading,
    error,
    fetchCategories,
    addCategory,
    updateCategory,
    deleteCategory,
    buildCategoryTree,
  };
};
